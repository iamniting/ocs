"""This python script is usefull for seeing the output of
"heketi-cli server state examine gluster" in parts instead of wide output
"""
import commands
import json
import os


def printmsg(msg):
    rows, columns = os.popen('stty size', 'r').read().split()
    col = int(columns) / 2

    if len(msg) > int(columns):
        style = (10 * "=", " %s ", 10 * "=")
        style = ''.join(style)
        style = style % msg
        print style
        return

    style = (col * "=", " %s ", col * "=")
    style = ''.join(style)
    style = style % msg

    length = len(style)
    diff = int(length) - int(columns)
    print style[diff/2:-diff/2]


output = commands.getoutput('heketi-cli server state examine gluster')
out = {}
out = json.loads(output)

printmsg("report")
print json.dumps(out['report'], indent=4)

#print json.dumps(out['heketidb'], indent=4)

### data from heketidb
heketidb = {}
heketidb = out['heketidb']

### clusters
printmsg("clusters in heketidb")
print "total: %s" % len(heketidb['clusterentries'].keys())
for cluster in heketidb['clusterentries'].keys():
    print json.dumps(heketidb['clusterentries'][cluster], indent=4)

### nodes
printmsg("nodes in heketidb")
print "total: %s" % len(heketidb['nodeentries'].keys())
for node in heketidb['nodeentries'].keys():
    print json.dumps(heketidb['nodeentries'][node], indent=4)

### devices
printmsg("devices in heketidb")
print "total: %s" % len(heketidb['deviceentries'].keys())
for device in heketidb['deviceentries'].keys():
    print json.dumps(heketidb['deviceentries'][device], indent=4)

### volumes
printmsg("volumes in heketidb")
print "total: %s" % len(heketidb['volumeentries'].keys())
for vol in heketidb['volumeentries'].keys():
    print json.dumps(heketidb['volumeentries'][vol], indent=4)

### blockvolumes
printmsg("blockvolumes in heketidb")
print "total: %s" % len(heketidb['blockvolumeentries'].keys())
for bvol in heketidb['blockvolumeentries'].keys():
    print json.dumps(heketidb['blockvolumeentries'][bvol], indent=4)

### bricks
printmsg("bricks in heketidb")
print "total: %s" % len(heketidb['brickentries'].keys())
for brick in heketidb['brickentries'].keys():
    print json.dumps(heketidb['brickentries'][brick], indent=4)

### dbattributeentries
printmsg("dbattribute in heketidb")
print json.dumps(heketidb['dbattributeentries'], indent=4)

### pendingoperations
printmsg("pendingoperations in heketidb")
print json.dumps(heketidb['pendingoperations'], indent=4)

#print json.dumps(out['clusters'], indent=4)

### data from gluster nodes
clusters = {}
clusters = out['clusters']

for cluster in clusters:
    printmsg("clusters from gluster server")
    print "id: %s" % cluster['ClusterHeketiID']
    for node in cluster['NodesData']:
        nodeid = node['NodeHeketiID']
        hostname = (
            heketidb['nodeentries'][nodeid]['Info']['hostnames']['manage'][0])

        printmsg("node from gluster server %s" % hostname)
        print "id: %s" % nodeid
        print "hostname: %s" % hostname

        printmsg("pvs from gluster server %s" % hostname)
        print "total: %s" % len(node['LVMPVInfo']['report'][0]['pv'])
        print json.dumps(node['LVMPVInfo'], indent=4)

        printmsg("vgs from gluster server %s" % hostname)
        print "total: %s" % len(node['LVMVGInfo']['report'][0]['vg'])
        print json.dumps(node['LVMVGInfo'], indent=4)

        printmsg("lvs from gluster server %s" % hostname)
        print "total: %s" % len(node['LVMLVInfo']['report'][0]['lv'])
        print json.dumps(node['LVMLVInfo'], indent=4)

        printmsg("block vol names from gluster server %s" % hostname)
        print "total: %s" % len(node['BlockVolumeNames'])
        print json.dumps(node['BlockVolumeNames'], indent=4)

        printmsg("brick mount status from gluster server %s" % hostname)
        print "total: %s" % len(node['BricksMountStatus']['Statuses'])
        print json.dumps(node['BricksMountStatus'], indent=4)

        printmsg("volumes from gluster server %s" % hostname)
        print "total: %s" % len(node['VolumeInfo']['Volumes']['VolumeList'])
        for vol in node['VolumeInfo']['Volumes']['VolumeList']:
            print json.dumps(vol, indent=4)
