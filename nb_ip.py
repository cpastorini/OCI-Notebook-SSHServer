import oci
import os

#print("- get NB_SESSION_OCID")
NB_OCID = os.environ.get("NB_SESSION_OCID")
if NB_OCID is None:
    raise Exception("NB_SESSION_OCID environment variable is required.")

#print("- init RP")
RP = os.environ.get("OCI_RESOURCE_PRINCIPAL_VERSION")

if not RP:
    # LOCAL RUN
    config = oci.config.from_file("~/.oci/config", "DEFAULT")
    dsc = oci.data_science.DataScienceClient(config=config)
    network = oci.core.VirtualNetworkClient(config=config)
else:
    # NB RP
    signer = oci.auth.signers.get_resource_principals_signer()
    dsc = oci.data_science.DataScienceClient(config={}, signer=signer)
    network = oci.core.VirtualNetworkClient(config={}, signer=signer)

#print("- get notebook data")
nb = dsc.get_notebook_session(NB_OCID).data
#print(f"- notebook data: {nb}")

if not nb.notebook_session_configuration_details or not nb.notebook_session_configuration_details.subnet_id:
    raise Exception("IP Address cannot be determined when Default Networking is in use! For SSH tunneling to work, you must specify your own VCN and Private subnet!")

#print("- get notebook subnet")
subnet_id = nb.notebook_session_configuration_details.subnet_id
#print(f"- notebook subnet ocid: {subnet_id}")

#print("- get subnet data")
subnet = network.get_subnet(subnet_id).data

#print("- fetching subnet private IPs")
private_ips = oci.pagination.list_call_get_all_results(
    network.list_private_ips, subnet_id=subnet_id
).data

#print("- finding the private IP for notebook session")
display_name = NB_OCID.split(".")[-1]
private_ip = [i for i in private_ips if i.display_name == display_name][0]

#print(f"- private IP address: {private_ip.ip_address}")

# Stampa l'indirizzo IP privato
print(f"{private_ip.ip_address}")
