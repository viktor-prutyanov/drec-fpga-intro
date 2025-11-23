import vitis

XSA_PATH = 'fpga/design_1_wrapper.xsa'

WORKSPACE = 'vitis'
PLATFORM_NAME = 'zynq_platform'
DOMAIN_NAME = 'standalone_ps7_cortexa9'

client = vitis.create_client()

client.set_workspace(path=WORKSPACE)

platform = client.create_platform_component(
    name=PLATFORM_NAME,
    hw_design=XSA_PATH,
    cpu="ps7_cortexa9_0",
    os="linux",
    domain_name=DOMAIN_NAME
)

platform.build()

client.close()
