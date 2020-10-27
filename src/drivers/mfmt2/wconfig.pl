#!/usr/bin/perl -w
use Scalar::Util qw(looks_like_number);
use File::Spec;

my ($NATIVEW,$NATIVEH) = (480,320);
my ($TRIMW,$TRIMH) = (12,6);
my ($SW,$SH) = ($NATIVEW-$TRIMW,$NATIVEH-$TRIMH);
my ($ITCW,$ITCH) = (100,32);
my ($VIZINDENT) = (3);
my ($GRIDINDENT) = (1);
my ($TW,$TH) = ($SW-2*$VIZINDENT,$SH-2*$VIZINDENT);
my ($GW,$GH) = ($SW-2*$GRIDINDENT,$SH-2*$GRIDINDENT);
my ($CORNERW,$CORNERH) = (6,6);
my ($STATICW,$STATICH) = ($TW/3,28);

my $MENUITEMBG = "#ccbb22";
my $MENUITEMFG = "#112233";

#my $CONTROLBG = "#aa8822";
#my $CONTROLFG = "#3344aa";

my $CONTROLBG = "#772255";
my $CONTROLFG = "#ffee99";

my $FLASHBG = "#993333";

my $AUTOGEN_STAMP =
    "# AUTOGENERATED FILE - DO NOT EDIT\n".
    "#  CREATED BY ". File::Spec->rel2abs($0)."\n".
    "#  ON ".scalar(localtime)."\n".
    "#  (IF ABSOLUTE TIME REALLY HAS ANY MEANING)\n";

sub intifnum {
    my $v = shift;
    return int($v) if looks_like_number($v);
    return $v;
}

sub geomForTile {
    my ($pw,$ph,$sw,$sh,$x,$y,$xm,$ym,$pad) = @_;
    $xm = $x unless defined $xm;
    $ym = $y unless defined $ym;
    $pad = 0 unless defined $pad;
    my $hpad = int($pad/2);
    my ($ppsw, $ppsh) = ($pw/$sw,$ph/$sh);
    my ($slotsw,$slotsh) = ($xm-$x+1,$ym-$y+1);
    my ($pptw, $ppth) = ($ppsw*$slotsw-$pad,$ppsh*$slotsh-$pad);
    my ($pxs,$pys) = ($ppsw*$x, $ppsh*$y);
    my ($pxt,$pyt) = ($pxs+$hpad,$pys+$hpad);
    return (int($pptw),int($ppth),int($pxt),int($pyt));
}
sub bfs3x3 { # Bordered full screen 3x3
    my ($x,$y,$xm,$ym) = @_;
    return join(" ",geomForTile($TW,$TH,3,3,$x,$y,$xm,$ym,8));
}
sub bfs6x6 { # Bordered full screen 6x6
    my ($x,$y,$xm,$ym) = @_;
    return join(" ",geomForTile($TW,$TH,6,6,$x,$y,$xm,$ym,8));
}

my $wconfig = <<__EOF__;
$AUTOGEN_STAMP
[Root Root - $SW $SH 0 0]
    bgcolor=#ff0033
    doc="The unique root panel that has no parent"
# CHILDREN OF ROOT
[Grid ChooserPanel Root `bfs6x6(0,0,5,5)`]
    bgcolor=$CONTROLBG
[Grid_k_fcdist_less FlashCommandLabel Grid `bfs6x6(0,0,0,0)`]
    enabledbg=$CONTROLBG
    bdcolor=$CONTROLBG
    enabledfg=#cccc00
    iconslot=1
    visible=1
    font=1
[Grid_k_fcdist_down FlashCommandLabel Grid `bfs6x6(1,0,1,0)`]
    enabledbg=$CONTROLBG
    bdcolor=$CONTROLBG
    enabledfg=#cccc00
    iconslot=2
    visible=1
    font=1
[Grid_k_fcdist_dist FlashCommandLabel Grid `bfs6x6(2,0,3,0)`]
    enabledbg=$CONTROLBG
    bdcolor=$CONTROLBG
    enabledfg=#cccc00
    iconslot=7
    visible=1
    font=1
    text=10
[Grid_k_fcdist_up FlashCommandLabel Grid `bfs6x6(4,0,4,0)`]
    enabledbg=$CONTROLBG
    bdcolor=$CONTROLBG
    enabledfg=#cccc00
    iconslot=4
    visible=1
    font=1
[Grid_k_fcdist_more FlashCommandLabel Grid `bfs6x6(5,0,5,0)`]
    enabledbg=$CONTROLBG
    bdcolor=$CONTROLBG
    enabledfg=#cccc00
    iconslot=5
    visible=1
    font=1
[Grid_k_fcdist_prepared FlashCommandLabel Grid `bfs6x6(0,2,5,3)`]
    enabledbg=$CONTROLBG
    bdcolor=$CONTROLBG
    enabledfg=#cccc00
    visible=1
    font=1
[Grid_k_fcdist_gogogo FlashCommandLabel Grid `bfs6x6(2,4,3,5)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text=" ENGAGE"
[Grid_kX MenuItem Grid `bfs6x6(4,4,5,5)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="X"
    action="RETURN"
[GlobalMenu ChooserPanel Root $TW $TH $VIZINDENT $VIZINDENT]
    bgcolor=#333366
    visible=1
    doc="Top level operations switcher"
[Flash ChooserPanel Root $TW $TH $VIZINDENT $VIZINDENT]
    bgcolor=$FLASHBG
    visible=1
    doc="Long-range operations switcher"
## FC: FLASH CONTROL
[FC ChooserPanel Root $TW $TH $VIZINDENT $VIZINDENT]
    bgcolor=$CONTROLBG
    visible=1
    doc="Long-range operations switcher"
## FC_kids
[FC_kT2 MenuItem FC `bfs3x3(0,0)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="T2Tile"
    action="GO FC_T2"
[FC_kPHY MenuItem FC `bfs3x3(1,0)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="Physics"
    action="GO FC_PHY"
[FC_kMFM MenuItem FC `bfs3x3(0,1)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="MFMT2"
    action="GO FC_MFM"
[FC_kDISP MenuItem FC `bfs3x3(1,1)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="Display"
    action="GO FC_DISP"
# [FC_kGRID MenuItem FC `bfs3x3(0,2)`]
#     enabledbg=$MENUITEMBG
#     enabledfg=$MENUITEMFG
#     font=1
#     text="GRID"
#     action="GO FC_DISP"
[FC_kX MenuItem FC `bfs3x3(2,2)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="X"
    action="RETURN"
## FC_T2: T2TILE FLASH ITEMS
[FC_T2 ChooserPanel Root $TW $TH $VIZINDENT $VIZINDENT]
    bgcolor=$CONTROLBG
    visible=1
    doc="Long-range operations switcher"
[FC_T2_k_t2t_boot T2RadioButton FC_T2 `bfs3x3(0,0)`]
    radiogroup="FC"
    font=12
    text=Boot
[FC_T2_k_t2t_off T2RadioButton FC_T2 `bfs3x3(1,0)`]
    radiogroup="FC"
    font=12
    text=Off
[FC_T2_k_t2t_xcdm T2RadioButton FC_T2 `bfs3x3(2,0)`]
    radiogroup="FC"
    font=12
    text="x CDM"
[FC_T2_kGrid MenuItem FC_T2 `bfs3x3(0,2)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text=Grid
    action="GO Grid"
# [FC_T2_kTile MenuItem FC_T2 `bfs3x3(1,2)`]
#     enabledbg=$MENUITEMBG
#     enabledfg=$MENUITEMFG
#     font=1
#     text=Here
#     action="GO Here"
[FC_T2_kX MenuItem FC_T2 `bfs3x3(2,2)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text=X
    action="GO FC"
## FC_MFM: MFMT2 FLASH ITEMS
[FC_MFM ChooserPanel Root $TW $TH $VIZINDENT $VIZINDENT]
    bgcolor=$CONTROLBG
    visible=1
    doc="Long-range operations switcher"
[FC_MFM_k_mfm_run T2RadioButton FC_MFM `bfs3x3(0,0)`]
    radiogroup="FC"
    font=12
    text="RUN"
[FC_MFM_k_mfm_pause T2RadioButton FC_MFM `bfs3x3(1,0)`]
    radiogroup="FC"
    font=12
    text="PAUSE"
[FC_MFM_k_mfm_crash T2RadioButton FC_MFM `bfs3x3(0,1)`]
    radiogroup="FC"
    font=12
    text="CRASH"
[FC_MFM_k_mfm_quit T2RadioButton FC_MFM `bfs3x3(1,1)`]
    radiogroup="FC"
    font=12
    text="QUIT"
[FC_MFM_k_mfm_dump T2RadioButton FC_MFM `bfs3x3(2,0)`]
    radiogroup="FC"
    font=12
    text="DUMP"
[FC_MFM_kGrid MenuItem FC_MFM `bfs3x3(0,2)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text=Grid
    action="GO Grid"
# [FC_MFM_kTile MenuItem FC_MFM `bfs3x3(1,2)`]
#     enabledbg=$MENUITEMBG
#     enabledfg=$MENUITEMFG
#     font=1
#     text=Here
#     action="GO Here"
[FC_MFM_kX MenuItem FC_MFM `bfs3x3(2,2)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text=X
    action="GO FC"
## FC_PHY: PHYSICS FLASH ITEMS
[FC_PHY ChooserPanel Root $TW $TH $VIZINDENT $VIZINDENT]
    bgcolor=$CONTROLBG
    visible=1
    doc="Long-range operations switcher"
[FC_PHY_k_phy_clear T2RadioButton FC_PHY `bfs3x3(0,0)`]
    radiogroup="FC"
    font=12
    text="CLEAR"
[FC_PHY_k_phy_seed1 T2RadioButton FC_PHY `bfs3x3(1,0)`]
    radiogroup="FC"
    font=12
    text="SEED1"
[FC_PHY_k_phy_seed2 T2RadioButton FC_PHY `bfs3x3(2,0)`]
    radiogroup="FC"
    font=12
    text="SEED2"
[FC_PHY_kGrid MenuItem FC_PHY `bfs3x3(0,2)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text=Grid
    action="GO Grid"
# [FC_PHY_kTile MenuItem FC_PHY `bfs3x3(1,2)`]
#     enabledbg=$MENUITEMBG
#     enabledfg=$MENUITEMFG
#     font=1
#     text=Here
#     action="GO Here"
[FC_PHY_kX MenuItem FC_PHY `bfs3x3(2,2)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text=X
    action="GO FC"
## FC_DISP: DISPLAY FLASH ITEMS
[FC_DISP ChooserPanel Root $TW $TH $VIZINDENT $VIZINDENT]
    bgcolor=$CONTROLBG
    visible=1
    doc="Long-range operations switcher"
[FC_DISP_k_dsp_sites T2RadioButton FC_DISP `bfs3x3(0,0)`]
    radiogroup="FC"
    font=12
    text="SITES"
[FC_DISP_k_dsp_tile T2RadioButton FC_DISP `bfs3x3(1,0)`]
    radiogroup="FC"
    font=12
    text="TILE"
[FC_DISP_k_dsp_cdm T2RadioButton FC_DISP `bfs3x3(2,0)`]
    radiogroup="FC"
    font=12
    text="CDM"
[FC_DISP_k_dsp_tq T2RadioButton FC_DISP `bfs3x3(0,1)`]
    radiogroup="FC"
    font=12
    text="TQ"
[FC_DISP_k_dsp_log T2RadioButton FC_DISP `bfs3x3(1,1)`]
    radiogroup="FC"
    font=12
    text="LOG"
[FC_DISP_kGrid MenuItem FC_DISP `bfs3x3(0,2)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text=Grid
    action="GO Grid"
# [FC_DISP_kTile MenuItem FC_DISP `bfs3x3(1,2)`]
#     enabledbg=$MENUITEMBG
#     enabledfg=$MENUITEMFG
#     font=1
#     text=Here
#     action="GO Grid"
[FC_DISP_kX MenuItem FC_DISP `bfs3x3(2,2)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text=X
    action="GO FC"
[PhysicsCtl ChooserPanel Root $TW $TH $VIZINDENT $VIZINDENT]
    bgcolor=#333366
    visible=1
    doc="Physics control dispatcher"
[T2Viz Panel Root $TW $TH $VIZINDENT $VIZINDENT]
    bgcolor=#ffffff
    visible=1
    doc="T2Viz operations display"
[Log SimLog Root $TW $TH $VIZINDENT $VIZINDENT]
    visible=1
    bgcolor=#cccccc
    fgcolor=#333333
    font=2
    fontheightadjust=-6
    elevatorwidth=4
    doc="Internal engine log"
[TQ TQPanel Root $TW $TH $VIZINDENT $VIZINDENT]
    visible=1
    fgcolor=#ffffff
    bgcolor=#111111
    font=7
    fontheightadjust=-6
    elevatorwidth=4
    doc="Current time queue dump"
[CDM CDMPanel Root $TW $TH $VIZINDENT $VIZINDENT]
    visible=1
    fgcolor=#aaffff
    bgcolor=#551111
    font=0
    fontheightadjust=-12
    elevatorwidth=1
    doc="CDM status and control"
[CDM_Button_X MenuItem CDM `bfs6x6(5,5)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="X"
    action="GO GlobalMenu"
[Sites T2GridPanel Root $GW $GH $GRIDINDENT $GRIDINDENT]
    bgcolor=#222222
[HardButtonPanel HardButton Root `bfs3x3(1,1)`]
    bgcolor=#663333
    fgcolor=#ffffff
    font=1
    text="EJECT"
    visible=0
    doc="Pending hard button notification"
# GRANDCHILDREN AND BEYOND    
[Log_Button_X MenuItem Log `bfs6x6(5,0)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="X"
    action="GO GlobalMenu"
[TQ_Button_X MenuItem TQ `bfs6x6(5,5)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="X"
    action="GO GlobalMenu"
[TQ_Checkbox_Living T2TileLiveCheckbox TQ `bfs6x6(5,0,5,0)`]
    font=2
[GlobalMenu_Button_Sites MenuItem GlobalMenu `bfs6x6(0,0,1,1)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="Sites"
    action="GO Sites"
[GlobalMenu_Button_Flash MenuItem GlobalMenu `bfs6x6(2,2,3,3)`]
    enabledbg=$CONTROLBG
    enabledfg=$CONTROLFG
    font=1
    text="Control"
    action="GO FC"
[GlobalMenu_Button_Log MenuItem GlobalMenu `bfs6x6(4,2,5,3)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="Log"
    action="GO Log"
[GlobalMenu_Button_TQ MenuItem GlobalMenu `bfs6x6(0,2,1,3)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="TQ"
    action="GO TQ"
[GlobalMenu_Button_CDM MenuItem GlobalMenu `bfs6x6(0,4,1,5)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="CDM"
    action="GO CDM"
[GlobalMenu_Button_Physics MenuItem GlobalMenu `bfs3x3(2,0)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="Physics"
    action="GO PhysicsCtl"
[GlobalMenu_Button_T2Viz MenuItem GlobalMenu `bfs3x3(1,0)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    bgcolor=#ffffff
    fgcolor=#000000
    text="Tile"
    action="GO T2Viz"
[GlobalMenu_Button_X MenuItem GlobalMenu `bfs6x6(2,4,5,5)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    bgcolor=#ffffff
    fgcolor=#000000
    text="X"
    action="GO Sites"
[T2Info T2Info T2Viz $TW $TH 0 0]
    bgcolor=#040404
    fgcolor=#a0a0a0
[StaticInfo StaticPanel T2Viz $STATICW $STATICH $ITCW  `($TH-$STATICH)`]
    bgcolor=#dd22dd
    fgcolor=#ffffff
    font=5
    fontheightadjust=-6
    elevatorwidth=0
[StatusInfo StatusPanel T2Viz 100 200 40 40]
    bgcolor=#441199
    fgcolor=#ffffff
    font=2
    elevatorwidth=0
    fontheightadjust=-4
[TypeHistogram HistoPanel T2Viz 220 200 150 40]
    bgcolor=#441199
    fgcolor=#ffffff
    font=2
    elevatorwidth=0
    fontheightadjust=-4
[T2Info_Off_Button OffButton T2Viz `bfs6x6(3,5,3,5)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=4
    text="Off"
[T2Info_KillCDM_Button XCDMButton T2Viz `bfs6x6(4,5,4,5)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=4
    text="xCDM"
[T2Info_Quit_Button QuitButton T2Viz `bfs6x6(3,0,3,0)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=4
    text="Quit"
[T2Info_Crash_Button CrashButton T2Viz `bfs6x6(2,0,2,0)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=4
    text="Crash"
[T2Info_Dump_Button DumpButton T2Viz `bfs6x6(2,5,2,5)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=4
    text="Dump"
[T2Info_Boot_Button BootButton T2Viz `bfs6x6(5,1,5,1)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=4
    text="Boot"
#[Sub1 Label T2Viz 120 50 220 40]
#    bgcolor=#00ff00
#    fgcolor=#ff0000
#    iconslot=10
#    visible=1
#    text=X-ray
#[Sub2 Label T2Viz 200 30 200 100]
#    bgcolor=#0000ff
#    iconslot=15
#    text="Check box on"
[SimLog SimLog T2Viz 260 220 145 40]
    bgcolor=#cccccc
    fgcolor=#333333
    font=4
    fontheightadjust=-6
    elevatorwidth=4
    visible=0
#[ITC_NE ITC T2Viz $ITCW $ITCH `($TW/2+($TW/2-$ITCW)/2)` 0]
[ITC_NE ITC T2Viz $ITCW $ITCH `($TW-$ITCW)` 0]
#    text=NE
[ITC_ET ITC T2Viz $ITCH $ITCW `($TW-$ITCH)` `(($TH-$ITCW)/2)`]
#    text=ET
#[ITC_SE ITC T2Viz $ITCW $ITCH `($TW/2+($TW/2-$ITCW)/2)` `($TH-$ITCH)`]
[ITC_SE ITC T2Viz $ITCW $ITCH `($TW-$ITCW)` `($TH-$ITCH)`]
#    text=SE
#[ITC_SW ITC T2Viz $ITCW $ITCH `(($TW/2-$ITCW)/2)` `($TH-$ITCH)`]
[ITC_SW ITC T2Viz $ITCW $ITCH 0 `($TH-$ITCH)`]
#    text=SW
[ITC_WT ITC T2Viz $ITCH $ITCW 0 `(($TH-$ITCW)/2)`]
#    text=WT
#[ITC_NW ITC T2Viz $ITCW $ITCH `(($TW/2-$ITCW)/2)` 0]
[ITC_NW ITC T2Viz $ITCW $ITCH 0 0]
#    text=NW
[Corner_NW Panel T2Viz $CORNERW $CORNERH 0 0]
    bgcolor=#000000
    fgcolor=#0000ff
[Corner_NE Panel T2Viz $CORNERW $CORNERH `($TW-$CORNERW)` 0]
    bgcolor=#000000
    fgcolor=#0000ff
[Corner_SE Panel T2Viz $CORNERW $CORNERH `($TW-$CORNERW)` `($TH-$CORNERH)`]
    bgcolor=#000000
    fgcolor=#0000ff
[Corner_SW Panel T2Viz $CORNERW $CORNERH 0 `($TH-$CORNERH)`]
    bgcolor=#000000
    fgcolor=#0000ff
#[T2Viz_Checkbox_Living T2TileLiveCheckbox T2Viz `bfs6x6(3,3,4,3)`]
#    font=2
#    text="Run"
[T2Viz_Checkbox_X MenuItem T2Viz `bfs6x6(5,4,5,4)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=4
    text="X"
    action="GO GlobalMenu"
[PhysicsCtl_MFMRun T2RadioButton PhysicsCtl `bfs6x6(0,2,1,3)`]
    radiogroup="RP"
    font=1
    text="Run"
[PhysicsCtl_MFMPause T2RadioButton PhysicsCtl `bfs6x6(2,2,3,3)`]
    radiogroup="RP"
    font=1
    text="Pause"
# [PhysicsCtl_Checkbox_Living T2TileLiveCheckbox PhysicsCtl `bfs6x6(0,2,2,3)`]
#     font=1
#     text="Run"
[PhysicsCtl_Checkbox_Listening T2TileListenCheckbox PhysicsCtl `bfs6x6(4,2,5,3)`]
    font=2
    text="I/O"
[PhysicsCtl_Button_Clear T2ClearTileButton PhysicsCtl `bfs3x3(0,0)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="Clear"
[PhysicsCtl_Button_Seed1 T2SeedPhysicsButton PhysicsCtl `bfs3x3(2,0,2,0)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="Seed #1"
[PhysicsCtl_Button_Seed2 T2SeedPhysicsButton PhysicsCtl `bfs3x3(1,0,1,0)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="Seed #2"
[PhysicsCtl_Button_Debug T2DebugSetupButton PhysicsCtl `bfs6x6(0,4,2,5)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="Init Debug"
[PhysicsCtl_Button_X MenuItem PhysicsCtl `bfs6x6(3,4,5,5)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="X"
    action="RETURN"
    
__EOF__

sub expand {
    my ($fn,$args) = @_;
    if ($fn eq "") { return int(eval($args)); }
    return eval "$fn($args)";
}
while ($wconfig =~ s/`(\w*)\(([^`]+)\)`/expand($1,$2)/e) { }

if ($wconfig =~ /`/) {
    print STDERR "Unbalanced/unrecognized ` remaining in '$wconfig'\n";
    exit 1
}
print $wconfig;

