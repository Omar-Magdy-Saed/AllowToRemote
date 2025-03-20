#!/bin/bash
################################################################################################
#
#  All rights reerved.
#  (C) 2008-2013, ALU, Vimercate
#
################################################################################################
#  TITLE          :  ???.sh
#  ABSTRACT       :  Automatic Installation Procedure Function
#  ENVIRONMENT    :  HP-UX / LX
#
################################################################################################
#  CREATED BY     :  xA.Brambilla - Jan 2013
################################################################################################
. `dirname $0`/../lib/utility.lib
 
 
MyUsage ()
{
  echo "Usage: ./`basename $0` <address>"
  echo "   Where:"
  echo "     <address>            addresss of remote server to be connected via ssh"
  echo "   Example:"
  echo "     ./`basename $0` 151.98.81.2"
  echo ""
  exit 1
}
 
  REMOTE_HOST="$1"
  [ ! -n "$REMOTE_HOST" ]  && MyUsage
  ping -c 1 ${REMOTE_HOST} > /dev/null
  if [ $? -ne 0 ];then
    error "node  <$REMOTE_HOST>, invalid or not reachable address"
    MyUsage
  fi
 
  REMOTE_CMD=""
  if [ ! -f /root/.ssh/id_dsa -a ! -f /.ssh/id_dsa ] ; then
    note "Creating SSH key ..."
    ssh-keygen -t dsa
  fi
  echo "Aligned SSH key on ${REMOTE_HOST}..."
  REMOTE_CMD="ssh root@${REMOTE_HOST}"
  ${REMOTE_CMD} '[ ! -d  .ssh ] && mkdir -m 0700 .ssh ; cat >> .ssh/authorized_keys && chmod 0600 .ssh/*' < ~/.ssh/id_dsa.pub
  if [ $? -ne 0 ] ; then
    echo "$REMOTE_HOST as root user is not accessible."
  fi
  # test if allow works properly
  ssh $REMOTE_HOST ls > /dev/null
  [ $? -eq 0 ] && note "allow remote server succesfully completed" || errorExit "allow remote server completed with error"