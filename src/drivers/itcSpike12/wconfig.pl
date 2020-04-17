#!/usr/bin/perl -w
use Scalar::Util qw(looks_like_number);
my ($NATIVEW,$NATIVEH) = (480,320);
my ($TRIMW,$TRIMH) = (12,6);
my ($SW,$SH) = ($NATIVEW-$TRIMW,$NATIVEH-$TRIMH);
my ($ITCW,$ITCH) = (100,32);
my ($VIZINDENT) = (3);
my ($TW,$TH) = ($SW-2*$VIZINDENT,$SH-2*$VIZINDENT);
my ($CORNERW,$CORNERH) = (6,6);
my ($STATICW,$STATICH) = ($TW-2*$ITCW,28);

my $MENUITEMBG = "#ccbb22";
my $MENUITEMFG = "#112233";

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
[Root Root - $SW $SH 0 0]
    bgcolor=#ff0033
    doc="The unique root panel that has no parent"
# CHILDREN OF ROOT
[GlobalMenu ChooserPanel Root $TW $TH $VIZINDENT $VIZINDENT]
    bgcolor=#333366
    visible=1
    doc="Top level operations switcher"
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
[Sites T2GridPanel Root $TW $TH $VIZINDENT $VIZINDENT]
    bgcolor=#222222
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
[GlobalMenu_Button_Log MenuItem GlobalMenu `bfs6x6(2,2,3,3)`]
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
[GlobalMenu_Button_X MenuItem GlobalMenu `bfs6x6(1,4,4,5)`]
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
[Sub1 Label T2Viz 120 50 220 40]
    bgcolor=#00ff00
    fgcolor=#ff0000
    iconslot=10
    visible=1
    text=X-ray
[Sub2 Label T2Viz 200 30 200 100]
    bgcolor=#0000ff
    iconslot=15
    text="Check box on"
[SimLog SimLog T2Viz 260 220 145 40]
    bgcolor=#cccccc
    fgcolor=#333333
    font=4
    fontheightadjust=-6
    elevatorwidth=4
    visible=0
#[ITC_NE ITC T2Viz $ITCW $ITCH `($TW/2+($TW/2-$ITCW)/2)` 0]
[ITC_NE ITC T2Viz $ITCW $ITCH `($TW-$ITCW)` 0]
    text=NE
[ITC_ET ITC T2Viz $ITCH $ITCW `($TW-$ITCH)` `(($TH-$ITCW)/2)`]
    text=ET
#[ITC_SE ITC T2Viz $ITCW $ITCH `($TW/2+($TW/2-$ITCW)/2)` `($TH-$ITCH)`]
[ITC_SE ITC T2Viz $ITCW $ITCH `($TW-$ITCW)` `($TH-$ITCH)`]
    text=SE
#[ITC_SW ITC T2Viz $ITCW $ITCH `(($TW/2-$ITCW)/2)` `($TH-$ITCH)`]
[ITC_SW ITC T2Viz $ITCW $ITCH 0 `($TH-$ITCH)`]
    text=SW
[ITC_WT ITC T2Viz $ITCH $ITCW 0 `(($TH-$ITCW)/2)`]
    text=WT
#[ITC_NW ITC T2Viz $ITCW $ITCH `(($TW/2-$ITCW)/2)` 0]
[ITC_NW ITC T2Viz $ITCW $ITCH 0 0]
    text=NW
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
[T2Viz_Checkbox_Living T2TileLiveCheckbox T2Viz `bfs6x6(3,3,4,3)`]
    font=2
    text="Run"
[PhysicsCtl_Checkbox_Living T2TileLiveCheckbox PhysicsCtl `bfs6x6(0,2,2,3)`]
    font=1
    text="Run"
[PhysicsCtl_Button_Clear MenuItem PhysicsCtl `bfs3x3(0,0)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="Clear"
    action="GO Sites"
[PhysicsCtl_Button_Seed MenuItem PhysicsCtl `bfs3x3(1,0,2,0)`]
    enabledbg=$MENUITEMBG
    enabledfg=$MENUITEMFG
    font=1
    text="Seed DReg"
    action="GO Sites"
[PhysicsCtl_Button_X MenuItem PhysicsCtl `bfs6x6(1,4,4,5)`]
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

