Service install

Note: bash shell required for scripts

----------

setup_service.sh

Part 1: Install Gridcoin netdata
  * Installs service files to /etc/systemd/system
  * Installs service script .sh file to /usr/local/bin
  * Installs gridcoin.chart.sh to /usr/libexec/netdata/charts.d
  * Makes both gridcoin_netdata_stats.sh and gridcoin_chart.sh executable

Part 2: Install Gricoin geography gather
  * Installs service files to /etc/systemd/system
  * Installs geo.json to /usr/local/bin
  * Installs service script .sh file to /usr/local/bin
  * Makes gridcoin_geo_scrape.sh executable

Part 3: Install Freegeoip
  * Makes crontab entry under user gridcoin to start freegeoip at boot
  * Copies license file to /usr/local/bin as required in both source code or binary release
  * Installs freegeoip binary to /usr/local/bin
  * Makes freegeoip executable

Part 4: Request permission to start services
  * Starts gridcoin_netdata_stats.timer (Defaultly set at 5 seconds)
  * Starts gridcoin_geo_scrape.timer (Defaultly set at 15 seconds)
  * Starts freegeoip under gridcoin through sudo -u gridcoin. After reboot it'll start from gridcoin crontab.

Important: geo.json contains data to determine country code to continent code.

Local API Notes:
* Setup to use standard HTTP on port 5000 (modify in crontab file)
* You can enable HTTPS (modify in .service file -- check /usr/local/bin/freegeoip --help)
* To setup HTTPS you will need to deal with certificates, etc.
* freegeoip can be downloaded @ https://github.com/fiorix/freegeoip/releases/ 
* Setup automatically downloads and extracts freegeoip
 
Personal Notes:
* I have firewall blocking all ports except ones I allow for node related task.
* I use HTTP for this application to minimally impact the enviroment.
* No outside access permitted to the 5000 in my firewall settings.
* Firewalls should be setup regardless.
* I recommend you run netdata through a webserver and make netdata a virtual server and enabled ssl for security.
* Also configure to block access to files like netdata.conf.
* Locally I'm using about 1.5 second of cpu time per 60 ips which is 40 times faster then online API

Online API Notes:
* You can modify a few items in script to use the online API of https://freegeoip.net/json/1.1.1.1
* This method is however slow and intensive on resources over longer period of time. (30 ips over 60 seconds)
* Online API requires modifying of the script and disabling of local API
* Online API limits 15000 requests an hour or 250 requests a minute.

Services start after 7 minutes after boot

Install: This may require sudo 
  * chmod +x setup_service.sh
  * ./setup_service.sh

----------

Manual Enable/Start

Enable:
  * systemctl enable gridcoin_netdata_stats.timer
  * systemctl enable gridcoin_geo_scrape.timer

Start:
  * systemctl start gridcoin_netdata_stats.timer
  * systemctl start gridcoin_geo_scrape.timer
  * sudo -u gridcoin /usr/local/bin/freegeoip -http 127.0.0.1:5000 -silent &

Verify:
  * systemctl status gridcoin_netdata_stats.timer
  * systemctl status gridcoin_geo_scrape.timer
  * ps aux | grep freegeoip
