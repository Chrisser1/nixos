# wifi login code
```bash
nmcli con add type wifi con-name "DTUsecure" ssid "DTUsecure" 802-1x.identity "USERNAME" 802-1x.password "PASSWORD" 802-1x.eap "peap" 802-1x.phase2-auth "mschapv2"
```