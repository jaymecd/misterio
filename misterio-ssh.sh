#!/bin/bash
set -e 
cd $(dirname $0)
misterio_cmd=$1
shift 1

for target in $* ; do 
    # Clone repo.
    # Send to target
    # run misterio
    # cleanup
    MISTERIO_HOME_DIR=/tmp/misterio-pack-$target
    if [ -d $MISTERIO_HOME_DIR  ]; then
        echo REMOVE $MISTERIO_HOME_DIR
        echo before proceeding
        exit 1
    fi
    set -u -x
    # GG: You can optioanally add a '-b master'
    # to use a fixed branch
    git clone --depth 2 file://$(pwd) $MISTERIO_HOME_DIR
    rsync -z  --delete $MISTERIO_HOME_DIR $target:$MISTERIO_HOME_DIR || scp -r $MISTERIO_HOME_DIR $target:$MISTERIO_HOME_DIR  >&/dev/null
    ssh $target $MISTERIO_HOME_DIR/misterio.sh $misterio_cmd || {
        echo @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        echo Misterio FAILED on $target 
        sleep 1
    }

    ssh $target rm -r $MISTERIO_HOME_DIR || { echo Removal failed; }
    rm -rf $MISTERIO_HOME_DIR
    set +x
done