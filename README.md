# Bosh CLI to Director

Director needs open 22,25555,6868,8443 for CLI/Bosh Init/Ops Manager to access

* 22 : bootstrap the agent
* 6868: Agent listens on 6868 as mbus so CLI can ping the agent
* 25555: The cli port
* If using uaa for director. Needs 8443 for CLI to communicate the director

# Deployed VM to director
Director needs open 4222, 25777,25250 for deployed VM to access

* 25777: Bosh registry, so the agents can get VMs configuration information to bootstrap
* 4222: NATs so the agents of VMs can report task status
* 25250: Internal Blobstore, so the compiling package can uploads compiled bits to the blobstore.
