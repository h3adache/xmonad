import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.SetWMName
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import XMonad.Layout.ResizableTile
import XMonad.Layout.ThreeColumns
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace (onWorkspace)
import XMonad.Layout.Fullscreen
import XMonad.Layout.Reflect
import System.IO

myModMask = mod4Mask  -- Rebind Mod to the Windows key
myScreensaver = "/usr/bin/mate-screensaver-command --lock"
myNormalBorderColor  = "#7c7c7c"
myFocusedBorderColor = "#ffb6b0"
myStartupHook = setWMName "LG3D"

myLayout = avoidStruts (
    ResizableTall 1 (3/100) (1/2) []
    ||| reflectHoriz (ResizableTall 1 (3/100) (1/2) [])
    ||| Mirror (ResizableTall 1 (3/100) (1/2) [])
    ||| Mirror (reflectHoriz (ResizableTall 1 (3/100) (1/2) []))
    ||| ThreeColMid 1 (3/100) (1/2)
    )

main = do
    xmproc <- spawnPipe "/usr/local/bin/xmobar /home/tchen/.xmonad/.xmobarrc"
    xmonad $ defaults {
            logHook = dynamicLogWithPP $ xmobarPP {
                ppOutput    = hPutStrLn xmproc,
                ppTitle     = xmobarColor "green" "" . shorten 50
            },
            manageHook = manageDocks <+> manageHook defaultConfig
        }
        `additionalKeys` [
            ((myModMask .|. shiftMask, xK_z), spawn myScreensaver),
            ((myModMask,               xK_a), sendMessage MirrorShrink),
            ((myModMask,               xK_z), sendMessage MirrorExpand)
        ]

defaults = defaultConfig {
    modMask             = myModMask,
    focusFollowsMouse   = False,
    normalBorderColor   = myNormalBorderColor,
    focusedBorderColor  = myFocusedBorderColor,
    layoutHook          = smartBorders $ myLayout ||| noBorders Full,
    startupHook         = myStartupHook
}
