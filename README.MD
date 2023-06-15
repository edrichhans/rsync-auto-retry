# Back up files using micro device

This project was created with the intention to use micro computers (such us my portable GL.iNet router running OpenWRT) as a backup device.

## Running

```shell
./run-sync-daemon.sh -s <source> -d <destination> -e <event>
```

This will run `rsync` in the background to copy the files from `<source>` to `<destination>/<event>`. Both the `source` and `destination` must be valid directories, while the `event` directory will be created if it doesn't exist.

If no flags are provided, the default values are configured for the go pro SD card plugged into the GL.iNet MT-1300 router, backing up to the hard drive.
- source: `/mnt/mmcblk0p1/DCIM/100GOPRO/`
- destination: `/mnt/One\ Touch/Go\ Pro/`
- event: current date in `YYYY-MM-DD`

### Retries

If the transfer fails at some point, the script will automatically retry the transfer. If the background process gets killed (if the device restarts, for example), just re-run the script, and it should picked up from where it previously left off.

### Output

The output is saved to `<event>_output.log` of the directory where the script was executed. Run `tail -f <event>_output.log` to keep track of the progress.

When the script has completed transferring the files, a file called `<event>.finished.txt` will be created.