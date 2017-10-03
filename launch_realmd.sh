#!/bin/bash

# Copyright 2017 Stephen SORRIAUX
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

BINDIR=/etc/mangos/bin
CONFDIR=/etc/mangos/conf
CONFIGS=/tmp

# seed with defaults included in the container image, this is the
# case when /realmdconf is not specified
cp $CONFDIR/* /tmp

if [ -f /realmdconf/realmd.conf ]; then
	echo "/realmdconf/realmd.conf is being used"
	CONFIGS=/realmdconf
fi

# populate template with env vars
sed -i "s/LOGIN_DATABASE_INFO/$LOGIN_DATABASE_INFO/g" $CONFIGS/realmd.conf

${BINDIR}/realmd -c $CONFIGS/realmd.conf
