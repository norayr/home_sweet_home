#!/bin/sh
BUSNAME="org.freesmartphone.ogsmd"
OBJECTPATH="/org/freesmartphone/GSM/Device"
METHODNAME="org.freesmartphone.GSM.PDP.DeactivateContext"
mdbus2 -s $BUSNAME $OBJECTPATH $METHODNAME

