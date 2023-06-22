#!/bin/bash

volume_count=3
volume_size=50
snapshot_name_prefix="snapshot"

for ((i=1; i<=volume_count; i++))
do
    volume_name="volume${i}"

    echo "Creating volume: ${volume_name}"
    openstack volume create --size ${volume_size} ${volume_name}

    snapshot_name="${snapshot_name_prefix}_${volume_name}"
    echo "Creating snapshot: ${snapshot_name}"
    volume_id=$(openstack volume show -f value -c id ${volume_name})
    openstack volume snapshot create --volume ${volume_id} ${snapshot_name}

    echo "Volume '${volume_name}' and snapshot '${snapshot_name}' created successfully."

    sleep 3

    # Delete the snapshot
    echo "Deleting snapshot: ${snapshot_name}"
    openstack volume snapshot delete ${snapshot_name}
    echo "Snapshot '${snapshot_name}' deleted successfully."

    # Delete the volume
    echo "Deleting volume: ${volume_name}"
    openstack volume delete ${volume_id}
    echo "Volume '${volume_name}' deleted successfully."

    echo
done
