# Chaos Engineering: Pod Termination Test

**Objective:** Validate that payment pods auto-recover within 60 seconds of unexpected termination.

## Steps

1. **Identify Pod**  
   `POD=$(kubectl get pods -l app=payment --field-selector=status.phase=Running -o jsonpath='{.items[0].metadata.name}')`

2. **Delete Pod**  
   `kubectl delete pod $POD --grace-period=0 --force`

3. **Verify Restart**  
   - Run `kubectl get pods -l app=payment --watch`; confirm new pod enters `Running` in < 60 s.

4. **Check Metrics & Alerts**  
   - Prometheus alert `PaymentPodRestarted` should fire and resolve.  
   - Confirm via API or UI.

5. **Inspect Controller Logs**  
   - `kubectl -n argocd logs deploy/argocd-application-controller | grep payment`

6. **Post-Test Actions**  
   - Document any failures or delays.  
   - Update chaos experiment parameters if recovery > 60 s.  
   - Feed results into the weekly resilience scorecard.
