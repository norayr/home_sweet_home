#!/bin/sh
APN="internet.orange"
USERNAME="x"
PASSWORD="x"
BUSNAME="org.freesmartphone.ogsmd"
OBJECTPATH="/org/freesmartphone/GSM/Device"
SETMETHODNAME="org.freesmartphone.GSM.PDP.SetCredentials"
ACTMETHODNAME="org.freesmartphone.GSM.PDP.ActivateContext"
mdbus2 -s $BUSNAME $OBJECTPATH $SETMETHODNAME $APN "$USERNAME" "$PASSWORD"
mdbus2 -s $BUSNAME $OBJECTPATH $ACTMETHODNAME
