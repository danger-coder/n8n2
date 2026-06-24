# UptimeRobot — Keep Render Free Tier Alive

Render's free web services **spin down after 15 min of inactivity**.
UptimeRobot's free plan pings every 5 minutes — enough to prevent sleep.

## Steps

### 1. Deploy to Render
1. Push this repo to GitHub.
2. Go to [render.com](https://render.com) → **New → Blueprint** → connect the repo.
3. Render reads `render.yaml` and creates the service automatically.
4. After the first deploy, copy the public URL (e.g. `https://n8n-xxxx.onrender.com`).
5. In Render → Environment → set `WEBHOOK_URL` to that URL.

### 2. Configure UptimeRobot
1. Sign up free at [uptimerobot.com](https://uptimerobot.com).
2. **New Monitor** → type: **HTTP(S)**
   - Friendly Name: `n8n`
   - URL: `https://your-app.onrender.com/healthz`
   - Monitoring Interval: **5 minutes**
3. Save. UptimeRobot will ping `/healthz` every 5 min, keeping the instance warm.

## Cost summary

| Service       | Plan  | Cost  | Limit                        |
|---------------|-------|-------|------------------------------|
| Render        | Free  | $0    | 750 h/month, 1 GB disk       |
| UptimeRobot   | Free  | $0    | 50 monitors, 5-min interval  |

## Reliability notes

- **Cold start**: If the instance does spin down (e.g. Render maintenance), restart
  takes ~30 s. Webhooks fired during that window will fail.
- **Disk persistence**: The 1 GB Render disk persists workflows and credentials
  across restarts (mapped to `/opt/render/project/data`).
- **Upgrade path**: Move to Render Starter ($7/mo) to eliminate spin-down entirely.
