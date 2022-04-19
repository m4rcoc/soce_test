
Install netconf-console tool:

pip install netconf-console




Execute get-config command:

netconf-console2 --port 830 --host <IP> -u <USERNAME> -p <PASSWORD> --db=running --get-config

Execute edit-config command:

netconf-console2 --port 830 --host <IP> -u <USERNAME> -p <PASSWORD> --db=running <XML config with RPC header>
