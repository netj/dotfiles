// Blink Shell Dosa theme
//
// Author: Jaeho Shin <netj@sparcs.org>
// Created: 2019-03-11
// See Also: https://github.com/blinksh/blink/blob/raw/Resources/FontsAndThemes.md

black       = '#2A3116';
red         = '#CC3300'; // red
green       = '#33CC33'; // green
yellow      = '#FFCC00'; // yellow
blue        = '#3366CC'; // blue
magenta     = '#BE1587'; // pink
cyan        = '#36D9D9'; // cyan
white       = '#EBEBEB'; // light gray
lightBlack  = '#5E6F27'; // medium gray
lightRed    = '#FF3333'; // red
lightGreen  = '#33FF33'; // green
lightYellow = '#FFFF33'; // yellow
lightBlue   = '#3399FF'; // blue
lightMagenta= '#FF33FF'; // pink
lightCyan   = '#33FFFF'; // cyan
lightWhite  = '#FFFFFF'; // white

t.prefs_.set('color-palette-overrides',
             [ black      , red          , green      , yellow         , 
               blue       , magenta      , cyan       , white          , 
               lightBlack , lightRed     , lightGreen , lightYellow    , 
               lightBlue  , lightMagenta , lightCyan  , lightWhite     ]);

t.prefs_.set('cursor-color', 'rgba(0, 255, 0, 0.9)');
t.prefs_.set('cursor-blink', true);
t.prefs_.set('foreground-color', '#ADB990');
t.prefs_.set('background-color', '#0D1100');
