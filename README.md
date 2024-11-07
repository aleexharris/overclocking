# Precision Boost Overdrive (PBO) Tuning a Ryzen 7950x

Looking to undervolt my Ryzen 7950x to bring temps and thus noise levels down, without an appreciable change in performance.

Step 1: Bring down the PBO curve optimiser offset in negative steps of 5, down to maximum of 30.

- [ ] -05: 5.2Ghz @ 215w down to 5.1Ghz @ 205w after 20 minutes.
- [ ] -10: 
- [ ] -15: 
- [ ] -20: 
- [ ] -25: 
- [ ] -30: 

Step 2: Decrease max power draw with the goal of 5.2Ghz across all cores at a lower power rating.

- [ ] 200w:
- [ ] 190w:
- [ ] 180w:
- [ ] 170w:

##  Testing

**1. Long-duration all-core test.**
- 8 hours smashing the CPU to test max temps and power draw.
- Can be run overnight easily. Wouldn't expect many failures.
- Run with the command `sudo ./long-test.sh` and then inputting your password to run as `sudo`.

**2. Short-duration per-core test.**
- 2 hours smashing each core/thread to test for stability of per-core limits.
- Individual cores can often have different minimum PBO curve optimiser offsets.
- Run with the command `sudo ./core-cycler.sh` and then inputting your password to run as `sudo`.

**3. Idle test.**
- 8 hour test of the PC on idle, followed by a 24 hour test.
- Test most likely to fail, as we are trying to have the CPU run on as little power as possible.
- Conveniently (not) also the most annoying test to run...
- Script still TBC

## References

- [[LINK](https://youtu.be/FaOYYHNGlLs?si=Cqt74Y2H7eYsW2zM)] Great overview off YouTube but misses some key testing points.

More indepth guides off Reddit:
- https://old.reddit.com/r/Amd/comments/khtx1o/guide_zen_3_overclocking_using_curve_optimizer/
- https://www.reddit.com/r/Amd/comments/qik4t3/zen_3_pbo_and_curve_optimizer/
- https://albertherd.com/2020/12/13/my-experience-with-precision-boost-overdrive-2-on-a-5900x/
