# DAWNBOOT

DawnBoot, (pronounced with latin accent, "donbot") is a web tool for initialization and maintenance
virtual appliances.

A Virtual Appliance is a system that performs a dedicated function, but rather than come in a physical package (like a 1U system), it comes in the form of an OVA, VMDK, or QCOW2 file.
Virtual Appliances are deployed on-premise into a private cloud, often by an overworked operational staff who are not experts on the dedicated function provided by the appliance.

The goal of DawnBoot is to enable the operational staff to quickly bring the virtual appliance up to a point where the primary (value added application) can be started on port-443, with a proper name
and associated HTTPS certificate.

An administrative login for the operational staff is created, and it does not use any default password for startup, preferring client-side certificates or long-term OAUTH Connect credentials.

DawnBoot can manage various aspects of the virtual appliance, including;

* hostname
* TLS certificates
* choice of where to get DNS
* network configuration: DHCPv4/RAv6, static configuration, cloud-init based configuration.
* database configuration: local database, replicated database, or connection to hosted database
* virtual router redundant protocol, RFC5798 for IPv4/IPv6, allowing for hot/warm standby
* discovery of the virtual appliance interface using mDNS/Bonjour and GRASP
* hitless upgrades of a virtual appliance through use of database replication and transition from hot to warm standby

So, DawnBoot initially runs on port 1080 of a new VM, and it initially provides for creation
only of a TLS certificate.
Once such a certificate has been created, then it restarts on port 1443 in a secure fashion, and additional functions are then supported.

DawnBoot is designed with absolutely minimal CSS and no essential JS.
A newly booted appliance can run elinks on a virtual console to provide for initial setup, or a remote browser to port-80 can be used.

DawnBoot depends upon a call-home protocol to setup the initial trust relationship and certificate name.
This eliminates any situation where any long-term secrets (private keys) are distributed with the virtual machine image.
This can also facilitate licensing of the primary application.

DawnBoot has an associated vendor system called NightClerk that the virtual appliance vendor is expected to run.


