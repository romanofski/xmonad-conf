-- most things copied from:
-- http://haskell.org/haskellwiki/Xmonad/Config_archive/31d1's_xmonad.hs
import XMonad
import qualified XMonad.StackSet as W

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import XMonad.Layout.LayoutHints
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.WindowArranger
import XMonad.Layout.Mosaic
import XMonad.Layout.Gaps

import XMonad.Util.Run
import XMonad.Util.Scratchpad
import XMonad.Util.WorkspaceCompare
import XMonad.Util.XSelection

import XMonad.Actions.UpdatePointer

import System.IO
import System.Exit


myTab = defaultTheme
    { activeColor         = "black"
    , inactiveColor       = "black"
    , urgentColor         = "yellow"
    , activeBorderColor   = "orange"
    , inactiveBorderColor = "#222222"
    , urgentBorderColor   = "black"
    , activeTextColor     = "orange"
    , inactiveTextColor   = "#222222"
    , urgentTextColor     = "yellow" }


myLayout = avoidStruts $ toggleLayouts (noBorders Full)
    (smartBorders (tiled ||| mosaic 2 [3,2] ||| Mirror tiled ||| layoutHints (tabbed shrinkText myTab)))
    where
        tiled   = layoutHints $ ResizableTall nmaster delta ratio []
        nmaster = 1
        delta   = 3/100
        ratio   = 1/2


-- special windows
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Aurora"         --> doShift "2:web"
    , className =? "Firefox"        --> doShift "2:web"
    , className =? "Opera"          --> doShift "2:web"
    , className =? "VirtualBox"     --> doShift "3:virtualbox"
    , title     =? "glxgears"       --> doFloat
    , className =? "Gnome-panel"    --> doIgnore
    , className =? "XVkbd"          --> doIgnore
    , className =? "Cellwriter"     --> doIgnore
    , className =? "Gtkdialog"      --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , isFullscreen                  --> doFullFloat
    --                                      x y w h
    , className =? "Unity-2d-panel" --> doIgnore
    , className =? "Unity-2d-launcher" --> doFloat
    , scratchpadManageHook $ W.RationalRect 0 0 1 0.42
    , manageDocks ] <+> manageHook defaultConfig


-- let Gnome know about Xmonad actions
-- myLogHook = ewmhDesktopsLogHookCustom scratchpadFilterOutWorkspace >> updatePointer Nearest

myWorkspaces = ["1:main", "2:web", "3:virtualbox", "4:whatever"]

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig {
        manageHook           = myManageHook
        , layoutHook         = myLayout
        , terminal           = "gnome-terminal"
        , logHook            = dynamicLogWithPP xmobarPP
                                { ppOutput = hPutStrLn xmproc
                                  , ppTitle = xmobarColor "green" "" . shorten 50
                                }
        , handleEventHook    = ewmhDesktopsEventHook
        , startupHook        = ewmhDesktopsStartup
        , workspaces         = myWorkspaces
}