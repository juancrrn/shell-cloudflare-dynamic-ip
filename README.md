# Shell script to manage dynamic IP addresses in Cloudflare DNS

## Introduction

Use this script as a template for managing dynamic IP addresses in Cloudflare DNS using API v4.

Documentation about updating a DNS record through Cloudflare API v4 is available here: https://api.cloudflare.com/#dns-records-for-a-zone-update-dns-record.

## Installation

1. Read the [documentation of the API](https://api.cloudflare.com/) and generate your authentication token.

2. Get your DNS zone's ID from your dashboard.

3. Get your DNS record's ID using the API:

```console
$ curl -X GET "https://api.cloudflare.com/client/v4/zones/ZONE_ID/dns_records" \
     -H "Authorization: Bearer TOKEN"
```

4. Install `jq` JSON parser:

```console
# apt install jq
```

5. Download the script file `cloudflare-dynamic-ip.sh` and fill in all the settings:

- Authentication
    - `TOKEN`
    - `ZONE_ID`
- Common record settings
    - `ZONE_NAME`
    - `RECORD_TYPE`
    - `RULE_PROXIABLE` (default `true`)
    - `RULE_PROXIED` (default `true`)
    - `RULE_LOCKED` (default `false`)
    - `STORED_IP`
- Specific record settings
    - `RECORD_ID`
    - `RECORD_NAME`

6. Create a `cloudflare-dynamic-ip-last.txt` for storing the last IP and preventing from calling the API if there is no change. Ensure that the user running the script has permission to read and write this file.

## Usage

Run the script:

```console
$ bash cloudflare-dynamic-ip.sh
```

## Cron

If you want to run the script programatically, you can use Cron jobs:

```console
# crontab -e
```

And add, for example:

```shell
0,14,29,44 * * * * /bin/bash /home/user/cloudflare-dynamic-ip.sh
```
