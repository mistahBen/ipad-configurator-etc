# ipad configurator etc
 Scripts and oneliners for working with ipad(s)

---
bash oneliners:

- erase iPad, install wifi profile, enroll in DEP. Handy for one-off resets.
`cfgutil pair && cfgutil erase && sleep 120 && cfgutil exec -a $HOME/path/to/wifi_dep.sh' && sleep 20 && cfgutil prepare --dep --skip-language --skip-region`
