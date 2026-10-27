# My Password Vault

A private password manager running on your own VPS, like Google Password
Manager or Samsung Pass, but you own it. It runs
[Vaultwarden](https://github.com/dani-garcia/vaultwarden), a server that
works with the free official **Bitwarden** apps and browser extensions.

You can reach it from **any device with a web browser**. You only need to
remember one password, your **master password**. You don't need your phone.

## What you need

1. A VPS running Linux (Ubuntu or Debian is easiest) with ports 80 and 443 open.
2. A domain or subdomain pointing at the VPS's IP address, for example
   `vault.yourname.com`. Add an **A record** at your domain provider.
   If you don't have a domain, [DuckDNS](https://www.duckdns.org) gives you a
   free one such as `myvault.duckdns.org`.
   You need HTTPS, and HTTPS needs a domain. The Bitwarden apps won't
   connect without it.

## Install (about 10 minutes)

Log into your VPS with SSH and run:

```bash
# 1. Install Docker (skip this if you already have it)
curl -fsSL https://get.docker.com | sh

# 2. Get this project
git clone https://github.com/MB-Etal/Trial-ACC.git
cd Trial-ACC/password-vault

# 3. Configure it
cp .env.example .env
nano .env          # set VAULT_DOMAIN to your domain, save with Ctrl+O, exit with Ctrl+X

# 4. Start it
docker compose up -d
```

Wait about a minute, then open `https://your-domain` in a browser.

## First-time setup

1. Click **Create account**. Choose a strong master password that you
   **will not forget**. A long phrase works well, for example
   `purple-kettle-river-jumps-42`. **Nobody can recover it for you**, not
   even you as the server owner. Write it on paper and keep it somewhere safe.
2. **Turn off sign-ups** so strangers can't make accounts on your server:
   ```bash
   nano .env              # change to SIGNUPS_ALLOWED=false
   docker compose up -d
   ```
3. In the web vault, go to **Settings → Security → Two-step login** and set up
   an authenticator app. **Save the recovery code** on paper next to your
   master password. Without it, losing your phone locks you out again.

## Get your passwords in

- **From Google / Chrome:** on any computer, go to
  [passwords.google.com](https://passwords.google.com) → ⚙ Settings →
  **Export passwords**. This gives you a `.csv` file.
- **From Samsung Pass:** in Samsung Pass settings, choose export (needs the phone).
- In your vault: **Tools → Import data** → choose "Chrome (csv)" → upload the file.
- **Delete the .csv file afterwards.** It holds all your passwords as plain text.

## Use it everywhere

Install the **Bitwarden** app or browser extension (Chrome, Firefox, Android,
iPhone). On the login screen, select the region/server dropdown →
**Self-hosted**, and enter `https://your-domain`. Then log in as usual.

## Backups (important!)

If the VPS dies, your passwords go with it unless you have a backup.

```bash
./backup.sh
```

This writes a file to `backups/`. Copy it **off the VPS** regularly, for example:

```bash
# run this on your own computer
scp root@YOUR_VPS_IP:~/Trial-ACC/password-vault/backups/*.tar.gz .
```

Also, every so often, use **Tools → Export vault** (encrypted JSON) from the
web vault and keep the file somewhere safe.

To run the backup automatically every night at 3am, run `crontab -e` and add:

```
0 3 * * * /root/Trial-ACC/password-vault/backup.sh
```

## Updating

```bash
cd ~/Trial-ACC/password-vault
docker compose pull
docker compose up -d
```

Do this every month or so to get security fixes.

## How safe is it?

- Your vault is **encrypted on your device** with your master password before
  it reaches the server. Someone who breaks into the VPS gets only scrambled data.
- Traffic uses HTTPS with an automatic Let's Encrypt certificate (via Caddy).
- The weak points are a guessable master password and having no backups.
  Avoid both.
