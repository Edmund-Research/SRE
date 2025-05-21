# Chaos Engineering: Deep Dive

Chaos engineering is the discipline of experimenting on a distributed system to build confidence in the system’s capability to withstand turbulent conditions in production.

---

## Objectives

1. **Validate Resilience**  
   Confirm that services automatically recover from failures (e.g., pod terminations, network faults).

2. **Uncover Hidden Weaknesses**  
   Detect single-points-of-failure and resource bottlenecks that normal testing might miss.

3. **Improve Recovery Processes**  
   Refine runbooks, automations, and alerting so Mean Time to Detect (MTTD) and Mean Time to Recover (MTTR) decrease continuously.

4. **Build Confidence**  
   Empower teams to release changes safely, knowing that failure modes have been exercised and mitigations are in place.

---

## Principles

- **Define “Steady State”**  
  Establish normal system metrics (latency, error rates, throughput) before experiments begin.

- **Automate and Repeat**  
  Chaos experiments should be codified scripts, runnable any time (e.g., as CI jobs or scheduled tasks).

- **Start Small, Scale Gradually**  
  Begin with limited blast radius (single pod), then expand to multi-service or infrastructure-level failures.

- **Monitor & Measure**  
  Use metrics, logs, and alerts to precisely capture system behavior and recovery timelines.

- **Learn and Iterate**  
  Feed experiment results back into architecture, runbooks, and monitoring rules to raise resilience over time.

---

## Further Reading

- [Principles of Chaos Engineering](https://principlesofchaos.org/)  
- [Chaos Monkey by Netflix](https://github.com/Netflix/chaosmonkey)  
- *Chaos Engineering* by Casey Rosenthal & Nora Jones  

