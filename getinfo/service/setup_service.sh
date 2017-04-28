#!/bin/bash
#
# Part 1: Install Gridcoin netdata stats to service
# Part 2: Install Gricoin geography gathering to service
# Part 3: Install Freegeoip as service
# Part 4: Permission to start services
#
# Added functions to accept inputs for starting services.
# Functions for setup

function serviceinstall {

        # Part 1
        #
        # Copy netdata service, chart and script.
        cp ./gridcoin_netdata_stats.service /etc/systemd/system
        cp ./gridcoin_netdata_stats.timer /etc/systemd/system
        cp ./gridcoin_netdata_stats.sh /usr/local/bin
        cp ./../gridcoin.chart.sh /usr/libexec/netdata/charts.d
        # Make chart and script executable
        chmod +x /usr/local/bin/gridcoin_netdata_stats.sh
        chmod +x /usr/libexec/netdata/charts.d/gridcoin.chart.sh

        # Part 2
        #
        # Copy geo scrape service, geo.json list, and script.
        cp ./gridcoin_geo_scrape.service /etc/systemd/system
        cp ./gridcoin_geo_scrape.timer /etc/systemd/system
        cp ./gridcoin_geo_scrape.sh /usr/local/bin
        cp ./geo.json /usr/local/bin/geo.json
        # Make script executable
        chmod +x /usr/local/bin/gridcoin_geo_scrape.sh

        # Part 3
        #
        # Copy freegeoip service, binary and license file
        cp ./gridcoin_freegeoip_service.service /etc/systemd/system
        cp ./freegeoip.license /usr/local/bin/freegeoip.license
        cp ./freegeoip /usr/local/bin
        # make freegeoip executable
        chmod +x /usr/local/bin/freegeoip

        # Part 4
        #
        # Ask to start services
        servicestartup
        exit 1
}

function servicestartup {

        read -p "Would you like to start these services at this time? (Y/N) " -n 1 choice
        echo
        case "$choice" in
                y|Y ) answer="Y";;
                n|N ) answer="N";;
        esac
        if [[ $answer ==  "Y" ]]
        then
                echo Enabling/Starting gridcoin_netdata_stats..
                systemctl enable gridcoin_netdata_stats.timer
                systemctl start gridcoin_netdata_stats.timer
                echo Enabling/Starting gridcoin_geo_scrape..
                systemctl enable gridcoin_geo_scrape.timer
                systemctl start gridcoin_geo_scrape.timer
                echo Enabling/Starting freegeoip..
                systemctl enable gridcoin_freegeoip_service.service
                systemctl start gridcoin_freegeoip_service.service
                echo Complete.. Verify service status.
                exit 1
        elif [[ $answer == "N" ]]
        then
                echo Read readme.md file for more information about Enabling/Starting services.
                exit 1
        else
                # Bad input??? Big fingers?? Those kind of moments then loop back into servicestartup for another go.
                servicestartup
                exit 1
        fi
        exit 1
}

# Run serviceinstall function
serviceinstall
