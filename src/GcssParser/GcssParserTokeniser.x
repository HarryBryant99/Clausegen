
{
module GcssParser.GcssParserTokeniser (Tokens(..),alexScanTokens) where

import Prelude hiding (Either(..))
}

%wrapper "basic"

$digit = 0-9
$hexdigit = [0-9a-fA-F]
$namechar = ~"

@namestring =  \" $namechar* \"
@longname = \" $namechar{0,5} $namechar{0,5} $namechar{0,5} \"
@shortname = \" $namechar{0,7} \"

@dayname = Mon | Tue | Wed | Thu | Fri | Sat | Sun

@hexstart = 0 ( x | X )
@hexnum = @hexstart $hexdigit+

tokens :-

$white+                                    ;
@namestring                                { \s -> NameString (reverse (tail (reverse (tail s)))) }
LONG                                       { \s -> Long }
SHORT                                      { \s -> Short }
INSTALLATION                               { \s -> Installation }
AUTHENTICATION                             { \s -> Authentication }
CODE                                       { \s -> Code }
CONFIGURATION                              { \s -> Configuration }
CONTROL                                    { \s -> Control }
INFORMATION                                { \s -> Information }
GCSS                                       { \s -> Gcss }
RELEASE $white* ($printable # $white)+     { \s -> Release }
CREATED                                    { \s -> Created }
BY                                         { \s -> By }
CURRENT                                    { \s -> Current }
VERSION                                    { \s -> Version }
STATUS                                     { \s -> Status }
NOT                                        { \s -> Not }
APPROVED                                   { \s -> Approved }
CHECKED                                    { \s -> Checked }
COMPILED                                   { \s -> Compiled }
CONSISTENT                                 { \s -> Consistent }
MODIFIED                                   { \s -> Modified }
MODIFICATION                               { \s -> Modification }
RECORD                                     { \s -> Record }
CHECKING                                   { \s -> Checking }
APPROVAL                                   { \s -> Approval }
ON                                         { \s -> On }
@dayname                                   { \s -> DayName s }
HEADER                                     { \s -> Header }
NAME                                       { \s -> Name }
ADDRESS                                    { \s -> Address }
CUSTOMER                                   { \s -> Customer }
INITIALISATION                             { \s -> Initialisation }
TIME                                       { \s -> Time }
COMMENTS                                   { \s -> Comments }
LADDER                                     { \s -> Ladder }
CONTENTS                                   { \s -> Contents }
RUNG                                       { \s -> Rung }
IS                                         { \s -> Is }
AND                                        { \s -> And }
CONTAINS                                   { \s -> Contains }
INSERT                                     { \s -> Insert }
AT                                         { \s -> At }
PURPOSE                                    { \s -> Purpose }
NOTES                                      { \s -> Notes }
ORIGIN                                     { \s -> Origin }
CELL                                       { \s -> Cell }
WITH                                       { \s -> With }
LINKS                                      { \s -> Links }
VALID                                      { \s -> Valid }
INVALID                                    { \s -> Invalid }
READONLY                                   { \s -> Readonly }
NORMALLY_OPEN                              { \s -> Normally_open }
NORMALLY_CLOSED                            { \s -> Normally_closed }
HORIZONTAL_SHUNT                           { \s -> Horizontal_shunt }
COIL                                       { \s -> Coil }
EMPTY                                      { \s -> Empty }
END_CONTACT                                { \s -> End_contact }
TOP                                        { \s -> Top }
BOTTOM                                     { \s -> Bottom }
LEFT                                       { \s -> Left }
NO                                         { \s -> No }
YES                                        { \s -> Yes }
HOUSING                                    { \s -> Housing }
HOUSINGS                                   { \s -> Housings }
MODULE                                     { \s -> Module }
SLOT                                       { \s -> Slot }
SEQUENCE                                   { \s -> Sequence }
NUMBER                                     { \s -> Num }
LATCHES                                    { \s -> Latches }
LATCH                                      { \s -> Latch }
TYPE                                       { \s -> Type }
HOT\-STANDBY                               { \s -> HotStandby }
STANDALONE                                 { \s -> StandAlone }
RESERVED                                   { \s -> Reserved }
TIMERS                                     { \s -> Timers }
TIMER                                      { \s -> Timer }
ACCESS                                     { \s -> Access }
TRIGGER                                    { \s -> Trigger }
DURATION                                   { \s -> Duration }
SETTING                                    { \s -> Setting }
NONE                                       { \s -> None }
R\/W                                       { \s -> RW }
FIXED                                      { \s -> Fixed }
DEFAULT                                    { \s -> Default }
COUNTER                                    { \s -> Counter }
USER                                       { \s -> User }
HVLM128                                    { \s -> Hvlm128 }
VPIM50                                     { \s -> Vpim50 }
CNVC                                       { \s -> Cnvc }
DIAG                                       { \s -> Diag }
NVC232                                     { \s -> Nvc232 }
VTC232                                     { \s -> Vtc232 }
VROM50                                     { \s -> Vrom50 }
EVTC                                       { \s -> Evtc }
FAULT                                      { \s -> Fault }
START                                      { \s -> Start }
INPUTS                                     { \s -> Inputs }
INPUT                                      { \s -> Input }
INITIAL                                    { \s -> Initial }
STATE                                      { \s -> State }
OUTPUTS                                    { \s -> Outputs }
OUTPUT                                     { \s -> Output }
FIELD                                      { \s -> Field }
RATE                                       { \s -> Rate }
DATA                                       { \s -> Data }
LANGUAGE                                   { \s -> Language }
SPEC                                       { \s -> Spec }
Processor                                  { \s -> Processor }
FCT                                        { \s -> Fct }
EQUIPMENT                                  { \s -> Equipment }
ID                                         { \s -> Id }
CED                                        { \s -> Ced }
RSAS                                       { \s -> Rsas }
OF                                         { \s -> Of }
DAY                                        { \s -> Day }
SET                                        { \s -> Set }
RESET                                      { \s -> Reset }
PORT                                       { \s -> Port }
ADJACENT                                   { \s -> Adjacent }
PAIR                                       { \s -> Pair }
ANNOTATIONS                                { \s -> Annotations }
BOOLEAN                                    { \s -> Boolean }
EQUATION                                   { \s -> Equation }
@hexstart $hexdigit{7}                     { \s -> HexNumber7 (read s) }
@hexstart $hexdigit{4}                     { \s -> HexNumber4 (read s) }
$digit{4}                                  { \s -> Number4 (read s) }
$digit{2}                                  { \s -> Number2 (read s) }
$digit+                                    { \s -> Number (read s) }
@hexnum                                    { \s -> Number (read s) }
\-                                         { \s -> Hyphen }
=                                          { \s -> Equals }
:                                          { \s -> Colon }
\,                                         { \s -> Comma }
\(                                         { \s -> LBrace }
\)                                         { \s -> RBrace }
\.                                         { \s -> Period }
\/                                         { \s -> ForwardSlash }
\_                                         { \s -> Underscore }
END                                        { \s -> End }
R                                          { \s -> R }
W                                          { \s -> W }
H                                          { \s -> H }
h                                          { \s -> H }
M                                          { \s -> M }
m                                          { \s -> M }
S                                          { \s -> S }
s                                          { \s -> S }
D                                          { \s -> D }
SR                                         { \s -> Sr }
CH                                         { \s -> Ch }
UN                                         { \s -> Un }
PM                                         { \s -> Pm }
PRIMARY                                    { \s -> Primary }
SECONDARY                                  { \s -> Secondary }
TIMEOUT_DELAY                              { \s -> Timeout_delay }
PM_CYCLE_TIME                              { \s -> Pm_cycle_time }
SOM24\(S\)                                 { \s -> Som24 }
SMB                                        { \s -> Smb }
REMOTE                                     { \s -> Remote }
FLASHING                                   { \s -> Flashing }
DARK                                       { \s -> Dark }
PERIOD                                     { \s -> PeriodText }
ANTIPHASE                                  { \s -> Antiphase }
DISABLED                                   { \s -> Disabled }
TRUE                                       { \s -> TrueText }
True                                       { \s -> TrueText }
FALSE                                      { \s -> FalseText }
False                                      { \s -> FalseText }
false                                      { \s -> FalseText }
PROVING                                    { \s -> Proving }
GROUP                                      { \s -> Group }
VITAL                                      { \s -> Vital }
NETWORK                                    { \s -> Network }
PORTS                                      { \s -> Ports }
NON                                        { \s -> Non }
NTP                                        { \s -> Ntp }
SERVER                                     { \s -> Server }
IP                                         { \s -> Ip }
READ                                       { \s -> ReadText }
Read                                       { \s -> ReadText }
PASSWORD                                   { \s -> Password }
WESTRACE                                   { \s -> Westrace }
WRITE                                      { \s -> WriteText }
DIGISAFE                                   { \s -> Digisafe }
UDP                                        { \s -> Udp }
LAG                                        { \s -> Lag }
MONITORING                                 { \s -> Monitoring }
MNEMONICS                                  { \s -> Mnemonics }
HIGH                                       { \s -> High }
LOW                                        { \s -> Low }
DETECTION                                  { \s -> Detection }
ZERO                                       { \s -> Zero }
HOLDING                                    { \s -> Holding }
POSITIVE                                   { \s -> Positive }
NEGATIVE                                   { \s -> Negative }
THRESHOLD                                  { \s -> Threshold }
RETAINED                                   { \s -> Retained }
AWS                                        { \s -> Aws }
PROTOCOL                                   { \s -> Protocol }
WNC                                        { \s -> Wnc }
INTERFACE                                  { \s -> Interface }
FILE                                       { \s -> File }
CHECKSUM                                   { \s -> Checksum }
SESSION                                    { \s -> Session }
DIAGNOSTIC                                 { \s -> Diagnostic }
OK                                         { \s -> Ok }
LOC                                        { \s -> Loc }
TIMEOUT                                    { \s -> Timeout }
WSA_S2_SERVER                              { \s -> Wsa_s2_server }
APPLICATION                                { \s -> Application }
WORD                                       { \s -> Word }
LENGTH                                     { \s -> Length }
INPUT_STATE                                { \s -> Input_state }
FLASH_NAME                                 { \s -> Flash_name }
PHASE_STATE                                { \s -> Phase_state }
OUTPUT_STATE                               { \s -> Output_state }
e256                                       { \s -> E256 }
SUBNET                                     { \s -> Subnet }
MASK                                       { \s -> Mask }
DESTINATION                                { \s -> Destination }
GATEWAY                                    { \s -> Gateway }
LIGHT                                      { \s -> Light }
POWER                                      { \s -> Power }
SUPPLY                                     { \s -> Supply }
PDI                                        { \s -> Pdi }
MULTICAST                                  { \s -> Multicast }
ELEMENT                                    { \s -> Element }
INDICATION                                 { \s -> Indication }
ERROR                                      { \s -> ErrorText }
NAMES                                      { \s -> Names }
FUNCTION                                   { \s -> Function }
CONFIRM                                    { \s -> Confirm }
PARAMETER                                  { \s -> Parameter }
INSTANCE                                   { \s -> Instance }
MNE                                        { \s -> Mne }
SDA                                        { \s -> Sda }
MIRROR                                     { \s -> Mirror }
FLT                                        { \s -> Flt }
COM                                        { \s -> Com }
ACCEPT                                     { \s -> Accept }
REJECT                                     { \s -> Reject }
MARKING                                    { \s -> Marking }
INDICATIONS                                { \s -> Indications }
LIST                                       { \s -> List }
TEXT                                       { \s -> Text }
REF                                        { \s -> Ref }
TPL                                        { \s -> Tpl }
TIN                                        { \s -> Tin }



{
data Tokens =
  Long                |
  Short               |
  Code                |
  Installation        |
  Authentication      |
  End                 |
  Configuration       |
  Control             |
  Information         |
  Gcss                |
  Release             |
  Created             |
  By                  |
  Current             |
  Version             |
  Status              |
  Not                 |
  Approved            |
  Checked             |
  Compiled            |
  Consistent          |
  Modified            |
  Modification        |
  Record              |
  Checking            |
  Approval            |
  On                  |
  Header              |
  Name                |
  Address             |
  Customer            |
  Initialisation      |
  Time                |
  Comments            |
  Ladder              |
  Contents            |
  Rung                |
  Is                  |
  And                 |
  Contains            |
  Insert              |
  At                  |
  Purpose             |
  Notes               |
  Origin              |
  Cell                |
  With                |
  Links               |
  Valid               |
  Invalid             |
  Readonly            |
  Normally_open       |
  Normally_closed     |
  Horizontal_shunt    |
  Coil                |
  Empty               |
  End_contact         |
  Top                 |
  Bottom              |
  Left                |
  No                  |
  Yes                 |
  Colon               |
  LBrace              |
  RBrace              |
  Comma               |
  Period              |
  ForwardSlash        |
  Housing             |
  Housings            |
  Module              |
  Slot                |
  Sequence            |
  Num                 |
  Latches             |
  Latch               |
  Type                |
  HotStandby          |
  StandAlone          |
  Reserved            |
  Timers              |
  Timer               |
  Access              |
  Counter             |
  Trigger             |
  Duration            |
  Setting             |
  None                |
  RW                  |
  Fixed               |
  Default             |
  User                |
  Hvlm128             |
  Vpim50              |
  Diag                |
  Nvc232              |
  Vtc232              |
  Vrom50              |
  Evtc                |
  Cnvc                |
  Fault               |
  Start               |
  Inputs              |
  Input               |
  Initial             |
  State               |
  Outputs             |
  Output              |
  Port                |
  Adjacent            |
  Field               |
  Data                |
  Language            |
  Spec                |
  Processor           |
  Fct                 |
  Equipment           |
  Id                  |
  Ced                 |
  Rsas                |
  Of                  |
  Day                 |
  Set                 |
  Reset               |
  Rate                |
  Pair                |
  Hyphen              |
  Annotations         |
  Boolean             |
  Equation            |
  Equals              |
  Underscore          |
  R                   |
  W                   |
  H                   |
  M                   |
  S                   |
  D                   |
  Sr                  |
  Ch                  |
  Un                  |
  Pm                  |
  Primary             | 
  Secondary           |
  Timeout_delay       |
  Pm_cycle_time       |
  Som24               |
  Smb                 |
  Remote              |
  Flashing            |
  Dark                |
  PeriodText          |
  Antiphase           |
  Disabled            |
  TrueText            |
  FalseText           |
  Proving             |
  Group               |
  Vital               |
  Network             |
  Ports               |
  Non                 |
  Ntp                 |
  Server              |
  Ip                  |
  ReadText            |
  Password            |
  Westrace            |
  WriteText           |
  Digisafe            |
  Udp                 |
  Lag                 |
  Monitoring          |
  Mnemonics           |
  High                |
  Low                 |
  Detection           |
  Zero                |
  Holding             |
  Positive            |
  Negative            |
  Threshold           |
  Retained            |
  Aws                 |
  Protocol            |
  Wnc                 |
  Interface           |   
  File                |
  Checksum            |
  Session             |
  Diagnostic          |
  Ok                  |
  Loc                 |
  Timeout             |
  Wsa_s2_server       |
  Application         |
  Word                |
  Length              |
  Input_state         |
  Flash_name          |
  Phase_state         |
  Output_state        |
  E256                |
  Subnet              |
  Mask                |
  Destination         |
  Gateway             |
  Light               |
  Power               |
  Supply              |
  Pdi                 |
  Multicast           |
  Element             | 
  Indication          |
  ErrorText           |
  Names               |
  Function            |
  Confirm             |
  Parameter           |
  Instance            |
  Mne                 |
  Sda                 |
  Mirror              |
  Flt                 |
  Com                 |
  Accept              |
  Reject              | 
  Marking             |
  Indications         |
  List                |
  Text                |
  Ref                 |
  Tpl                 |
  Tin                 |
  HexNumber4 Int      |
  HexNumber7 Int      |
  Number Int          |
  Number2 Int         |
  Number4 Int         |
  NameString String   |
  DayName String      
  deriving (Eq,Show)
}
