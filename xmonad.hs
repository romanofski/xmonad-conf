-- most things copied from:
-- http://haskell.org/haskellwiki/Xmonad/Config_archive/31d1's_xmonad.hs
import XMonad
import Data.List    -- isInfixOf

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName

import XMonad.Layout.LayoutHints
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Mosaic
import XMonad.Layout.Gaps

import XMonad.Util.Run
import XMonad.Util.WorkspaceCompare
import XMonad.Util.XSelection
import XMonad.Util.EZConfig (additionalKeys)

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


--
-- special windows
-- resource (also known as appName) is the first element in WM_CLASS(STRING) 
-- className is the second element in WM_CLASS(STRING)
-- title is WM_NAME(STRING)
-- http://www.haskell.org/haskellwiki/Xmonad/Frequently_asked_questions#I_need_to_find_the_class_title_or_some_other_X_property_of_my_program
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , fmap ("sun-awt-X11" `isInfixOf`) resource --> doFloat    -- java awt Windows e.g. dbvis
    , className =? "Aurora"         --> doShift "2:web"
    , className =? "Firefox"        --> doShift "2:web"
    , className =? "Opera"          --> doShift "2:web"
    , className =? "VirtualBox"     --> doShift "3:virtualbox"
    , title     =? "glxgears"       --> doFloat
    , className =? "XVkbd"          --> doIgnore
    , className =? "Cellwriter"     --> doIgnore
    , className =? "Gtkdialog"      --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , isFullscreen                  --> doFullFloat
    --                                      x y w h
    , className =? "Unity-2d-panel" --> doIgnore
    , className =? "Unity-2d-launcher" --> doFloat
    , manageDocks ] <+> manageHook defaultConfig

myWorkspaces = ["1:main", "2:web", "3:virtualbox", "4:whatever"]

main = do
    xmproc <- spawnPipe "~/.cabal/bin/xmobar -x 0"
    xmonad $ defaultConfig {
        manageHook           = myManageHook
        , layoutHook         = myLayout
        , terminal           = "terminator"
        , logHook            = dynamicLogString defaultPP >>= xmonadPropLog
        , handleEventHook    = ewmhDesktopsEventHook
        , startupHook        = do
            ewmhDesktopsStartup >> setWMName "LG3D"
            spawn "~/.xmonad/startup-hook"
        , workspaces         = myWorkspaces
    } `additionalKeys` [((mod1Mask .|. shiftMask, xK_l), spawn "xautolock -locknow")]
