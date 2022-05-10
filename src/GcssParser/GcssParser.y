{
    module GcssParser.GcssParser(gcss,VarMap,VarMaps,VarType(..)) where

import GcssParser.GcssParserTokeniser
import Ladder

}

%name gcss
%tokentype { Tokens }
%token
  long                { Long }
  short               { Short }
  code                { Code }
  installation        { Installation }
  authentication      { Authentication }
  end                 { End }
  configuration       { Configuration }
  control             { Control }
  information         { Information }
  gcss                { Gcss }
  release             { Release }
  created             { Created }
  by                  { By }
  current             { Current }
  version             { Version }
  status              { Status }
  not                 { Not }
  approved            { Approved }
  checked             { Checked }
  compiled            { Compiled }
  consistent          { Consistent }
  modified            { Modified }
  modification        { Modification }
  record              { Record }
  checking            { Checking }
  approval            { Approval }
  on                  { On }
  header              { Header }
  name                { Name }
  address             { Address }
  customer            { Customer }
  initialisation      { Initialisation }
  time                { Time }
  comments            { Comments }
  ladder              { Ladder }
  contents            { Contents }
  rung                { GcssParser.GcssParserTokeniser.Rung }
  is                  { Is }
  and                 { And }
  contains            { Contains }    
  insert              { Insert }
  at                  { At }
  purpose             { Purpose }
  notes               { Notes }
  origin              { Origin }
  cell                { GcssParser.GcssParserTokeniser.Cell }
  with                { With }
  links               { Links }
  valid               { Valid }
  invalid             { Invalid }
  readonly            { Readonly }
  normally_open       { Normally_open }
  normally_closed     { Normally_closed }
  horizontal_shunt    { Horizontal_shunt }
  coil                { Coil }
  empty               { GcssParser.GcssParserTokeniser.Empty }
  end_contact         { End_contact }
  top                 { Top }
  bottom              { Bottom }
  left                { GcssParser.GcssParserTokeniser.Left }
  no                  { No }
  yes                 { Yes }
  colon               { Colon }
  lbrace              { LBrace }
  rbrace              { RBrace }
  comma               { Comma }
  period              { Period }
  forwardslash        { ForwardSlash }
  housing             { Housing }
  housings            { Housings }
  module              { Module }
  slot                { Slot }
  sequence            { Sequence }
  num                 { Num }
  latches             { Latches }
  latch               { Latch }
  type                { Type }
  hotstandby          { HotStandby }
  standalone          { StandAlone }
  reserved            { Reserved }
  timers              { Timers }
  timer               { Timer }
  access              { Access }
  trigger             { Trigger }
  duration            { Duration }
  setting             { Setting }
  none                { None }
  readwrite           { RW }
  fixed               { Fixed }
  default             { Default }
  user                { User }
  hvlm128             { Hvlm128 }
  vpim50              { Vpim50 }
  diag                { Diag }
  nvc232              { Nvc232 }
  vtc232              { Vtc232 }
  vrom50              { Vrom50 }
  evtc                { Evtc }
  field               { Field }
  data                { Data }
  rate                { Rate }
  cnvc                { Cnvc }
  fault               { Fault }
  start               { Start }
  inputs              { Inputs }
  input               { Input }
  initial             { Initial }
  state               { State }
  outputs             { Outputs }
  output              { Output }
  port                { Port }
  adjacent            { Adjacent }
  pair                { Pair }
  hyphen              { Hyphen }
  annotations         { Annotations }
  boolean             { Boolean }
  equation            { Equation }
  equals              { Equals }
  read                { R }
  write               { W }
  hour                { H }
  minute              { M }
  second              { S }
  language            { Language }
  spec                { Spec }
  processor           { Processor }
  fct                 { Fct }
  equipment           { Equipment }
  id                  { Id }
  ced                 { Ced }
  rsas                { Rsas }
  of                  { Of }
  day                 { Day }
  sr                  { Sr }
  set                 { Set }
  reset               { Reset }
  ch                  { Ch }
  un                  { Un }
  d                   { D }
  pm                  { Pm }
  primary             { Primary }
  secondary           { Secondary }
  timeout_delay       { Timeout_delay }
  pm_cycle_time       { Pm_cycle_time }
  som24               { Som24 }
  smb                 { Smb }
  remote              { Remote }
  flashing            { Flashing }
  dark                { Dark }
  periodtext          { PeriodText }
  antiphase           { Antiphase }
  disabled            { Disabled }
  truetext            { TrueText }
  falsetext           { FalseText }
  proving             { Proving }
  group               { Group }
  vital               { Vital }
  network             { Network }
  ports               { Ports }
  non                 { Non }
  ntp                 { Ntp }
  server              { Server }
  ip                  { Ip }
  readtext            { ReadText }
  password            { Password }
  westrace            { Westrace }
  writetext           { WriteText }
  digisafe            { Digisafe }
  udp                 { Udp }
  lag                 { Lag }
  monitoring          { Monitoring }
  mnemonics           { Mnemonics }
  high                { High }
  low                 { Low }
  detection           { Detection }
  zero                { Zero }
  holding             { Holding }
  positive            { Positive }
  negative            { Negative }
  threshold           { Threshold }
  retained            { Retained }
  aws                 { Aws }
  protocol            { Protocol }
  wnc                 { Wnc }
  interface           { Interface }
  file                { File }
  checksum            { Checksum }
  session             { Session }
  diagnostic          { Diagnostic }
  ok                  { Ok }
  loc                 { Loc }
  timeout             { Timeout }
  wsa_s2_server       { Wsa_s2_server }
  application         { Application }
  word                { Word }
  length              { Length }
  input_state         { Input_state }
  flash_name          { Flash_name }
  phase_state         { Phase_state }
  output_state        { Output_state }
  e256                { E256 }
  subnet              { Subnet }
  mask                { Mask }
  destination         { Destination }
  gateway             { Gateway }
  light               { Light }
  power               { Power }
  supply              { Supply }
  pdi                 { Pdi }
  multicast           { Multicast }
  element             { Element } 
  indication          { Indication }
  errortext           { ErrorText }
  names               { Names }
  function            { Function }
  confirm             { Confirm }
  parameter           { Parameter }
  instance            { Instance }
  mne                 { Mne }
  sda                 { Sda }
  mirror              { Mirror }
  flt                 { Flt }
  com                 { Com }
  accept              { Accept }
  reject              { Reject } 
  marking             { Marking }
  indications         { Indications }
  list                { List }
  text                { Text }
  ref                 { Ref }
  tpl                 { Tpl }
  tin                 { Tin }
  underscore          { Underscore }
  hexnumber4          { HexNumber4 $$ }
  hexnumber7          { HexNumber7 $$ }
  number              { Number $$ }
  number2             { Number2 $$ }
  number4             { Number4 $$ }
  namestring          { NameString $$ }
  dayname             { DayName $$ }

%%

AnInstallation : installation namestring
                              ConfigurationControl
							  ProcessorDControl
							  FctControl
                              InstallationHeader
                              Ladder                             
                              HousingsNew
                              RsasCheck
                 end namestring
authentication code Number                 { ((fst($7),$8),snd($7)) }
                 
ConfigurationControl : configuration control information 
                       data language spec version VersionNum2
                       created by namestring
                       current version VersionNum
                       status colon 
                       ConfigurationControlFlags
                       modification record
                       VersionRecords
                       checking record
                       VersionRecords
                       approval record
                       VersionRecords
                       end configuration control            { () }

ProcessorDControl : processor d configuration control information 
                    data language spec version VersionNum2
                    created by namestring
                    current version VersionNum
                    status colon 
                    ConfigurationControlFlags
                    modification record
                    VersionRecords
                    checking record
                    VersionRecords
                    approval record
                    VersionRecords
                    end configuration control            { () }

FctControl : fct configuration control information 
             data language spec version VersionNum2
             created by namestring
             current version VersionNum
             status colon 
             ConfigurationControlFlags
             modification record
             VersionRecords
             checking record
             VersionRecords
             approval record
             VersionRecords
             end configuration control            { () }
                       
ConfigurationControlFlags : ConfigurationFlagApproved
                            ConfigurationFlagChecked
                            ConfigurationFlagCompiled
                            ConfigurationFlagConsistent
                            ConfigurationFlagModified       { () }
                            
ConfigurationFlagApproved : approved                        { True }
                          | not approved                    { False }
                          
ConfigurationFlagChecked : checked                          { True }
                         | not checked                      { False }
                         
ConfigurationFlagCompiled : compiled                        { True }
                          | not compiled                    { False }   

ConfigurationFlagConsistent : consistent                    { True }
                            | not consistent                { False }

ConfigurationFlagModified : modified                        { True }
                          | not modified                    { False } 

VersionNum : number2 period number4                         { ($1,$3) }

VersionNum2 : number period number                          { ($1,$3) }

VersionRecords : {- empty -}                                { [] }
               | VersionRecords VersionRecord               { $2 : $1 }

VersionRecord : version VersionNum by namestring on
                dayname Date Time                           { ($2,$4,$6,$7,$8) }

Date : number2 forwardslash number2 forwardslash number4    { ($1,$3,$5) }

Time : number2 colon number2 colon number2                  { ($1,$3,$5) }


InstallationHeader : installation header 
                     installation name namestring
                     installation address Number
					 equipment id Number
					 CedVersion
                     customer name namestring
                     initialisation time Number
                     CommentsTitle
                     end header                             { () }

CedVersion : ced version Number                             { () } 
           | ced version Number underscore Number           { () } 

CommentsTitle : comments 
                CommentsBody                                { () }
				
CommentsBody : {- empty -}                                  { () } 
             | CommentsBody CommentsInd                     { () } 
			 
CommentsInd : namestring                                    { () } 
            | tpl approval status namestring                { () } 
			| tin approval status namestring                { () }       
                     
Number : number2                                            { $1 }
       | number4                                            { $1 }
       | number                                             { $1 }

HexNumber : number                                          { $1 }
          | hexnumber4                                      { $1 }
		  | hexnumber7                                      { $1 }

Ladder : ladder contents
         Rungs
		 ReservedTimers
		 UserTimers
		 FieldTimers
		 UserLatches
		 TimeOfDayTimers
		 SRLatches
end ladder                                         {( (Root (reverse $3)), $9) }

Rungs : {- empty -}                                         { []::[Ladder] }
      | Rungs Rung                                          { $2 : $1 }

Rung : rung Number is Validity RungType
         Inserting
         purpose namestring
         notes namestring
         origin namestring
         Cells
       end rung Number                                      { Ladder.Rung $2 $13 }

Validity : valid                                            { True }
         | invalid                                          { False }

RungType : and readonly and contains                        { () }
         | and contains                                     { () }
         

Inserting: insert at namestring                             { True }
         | {- empty -}                                      { False }

Cells :                                                     { []::[Ladder] }
      | Cells Cell                                          { $2 : $1 }

Cell : cell lbrace number2 comma number2 rbrace is
       ContactType ContactName with Links links             { Ladder.Cell $3 $5 $8 $9 $11 }

ContactType : coil                                          { CellTypeCoil }
            | horizontal_shunt                              { CellTypeHorizontal_Shunt }
            | normally_open                                 { CellTypeNormally_Open }
            | normally_closed                               { CellTypeNormally_Closed }
            | empty                                         { CellTypeEmpty }
            | end_contact                                   { CellTypeEnd_Contact }

ContactName : namestring                                    { $1 }
            |                                               { []::[Char] }
            
Links : Link                                                { [$1] }
      | Links Link                                          { $2 : $1 }
            
Link : top                                                  { LinkTop }
     | left                                                 { LinkLeft }
     | bottom                                               { LinkBottom }
     | no                                                   { LinkNone }

Annotations : annotations end annotations                   { () }

HousingsNew : housings HousingsInd end housings             { $2 }

HousingsInd : {- empty -}                                   { []::VarMaps }
            | HousingsInd HousingNew                        { $2 ++ $1 }

HousingNew : housing Number ch HousingHeader HousingNewInfo end housing Number  { $5 }
           | housing Number un HousingHeader HousingNewInfo end housing Number  { $5 }

HousingNewInfo : {- empty -} 							    { []::VarMaps }
               | HousingNewInfo ModuleNew                   { $2 ++ $1 }

HousingHeader : {- empty -}									{ () }
			  | HousingRealHeader							{ () }

HousingRealHeader : header
					name equals namestring
					comments equals namestring
					power supply equals namestring
					end header								{ () }

ModuleNew : ModulePMPrim                                        { $1 }
          | ModulePMSec                                         { $1 }
		  | ModuleSOM                                           { $1 }


ModulePMPrim : module pm slot Number
               ModDec
			   ModType at housing Number slot Number
			   timeout_delay equals Number period Number
			   pm_cycle_time equals Number
               VitalPorts
               NonVitalPorts
			   NetworkConfigData
			   RemoteSMB
			   PDIConfigTop
			   end module                                    { $21 }

ModDec : ModDec1                                               { () }
	   | ModDec2                                               { () }

ModDec1 : type equals ModType                                 { () }

ModDec2 : type equals ModType  
	      name equals namestring
		  comments equals namestring                          { () }

ModulePMSec : module pm slot Number
              ModDec
			  ModType at housing Number slot Number
			  Sessions
			  end module                                    { $12 }

ModType : primary                                            { () }
        | secondary                                          { () }

VitalPorts : vital network ports
             NetworkPorts
			 end vital network ports                        { () }

NetworkPorts : {- empty -}                                  { () }
             | NetworkPorts NetworkPort                     { () }

NetworkPort : network port Number
              protocol equals wnc
			  interface file namestring
			  checksum equals HexNumber
			  version equals VersionNum
			  status equals ConfigurationFlagApproved
			  network Number primary ip address equals HexNumber
			  network Number secondary ip address equals HexNumber
			  network Number primary ip address equals HexNumber
			  network Number secondary ip address equals HexNumber
			  end network port Number                       { () }

NonVitalPorts : non vital network port
                Sessions
				end non vital network port                  { $5 }

Sessions : {- empty -}                                      { []::VarMaps }
         | Sessions Session                                 { $2 ++ $1 }

Session : SessionDiag                                       { $1 }
        | SessionServ                                       { $1 }

SessionDiag : session Number protocol equals diagnostic
              session ok equals namestring
			  loc timeout equals Number
			  diagnostic port address equals Number
			  end session Number                            { [($9, False, ModPMPrimInV)::VarMap] }

SessionServ : session Number protocol equals wsa_s2_server
              session ok equals namestring
			  loc timeout equals Number
			  application session id equals Number
			  network Number primary ip address equals HexNumber
			  network Number secondary ip address equals HexNumber
              network Number primary ip address equals HexNumber
			  network Number secondary ip address equals HexNumber
			  housing address equals Number
			  data word length equals e256
			  SessionInputs
			  SessionOutputs
			  end session Number                            { $56 ++ $57 }

SessionInputs : {- empty -}                                 { []::VarMaps }
              | SessionInputs SessionInput                  { $2:$1 }

SessionInput : input_state Number
               name equals namestring
			   flash_name equals namestring
			   phase_state equals namestring                { ($5, False, ModPMPrimInV)::VarMap }

SessionOutputs : {- empty -}                                { []::VarMaps }
               | SessionOutputs SessionOutput               { $2:$1 }

SessionOutput : output_state Number
                name equals namestring                      { ($5, False, ModPMPrimOutV)::VarMap }


NetworkConfigData : network configuration data
                    Networks
					Gateways
					ntp server Number ip address equals HexNumber
					ntp server Number ip address equals HexNumber
					ntp server Number ip address equals HexNumber
					ntp server Number ip address equals HexNumber
					readtext password equals westrace
					readtext writetext password equals westrace
					digisafe udp port equals Number
					end network configuration data          { () }

Networks : {- empty -}                                      { () }
         | Networks NetworkInd                              { () }

NetworkInd : network Number
             primary ip address equals HexNumber
			 primary subnet mask equals HexNumber
			 secondary ip address equals HexNumber
			 secondary subnet mask equals HexNumber						
			 end network Number                             { () }

Gateways : {- empty -}                                      { () }
         | Gateways GatewayInd                              { () }

GatewayInd : gateway Number
             ip address equals HexNumber
			 destination network address equals HexNumber
			 destination network mask equals HexNumber
			 end gateway Number                             { () }

RemoteSMB : start remote smb data
            network lag equals Number
			end remote smb data                             { () }

PDIConfigTop : {- empty -}                                  { () }
			 | PDIConfigData                                { () }

PDIConfigData : pdi configuration data
			    multicast primary ip address equals HexNumber
				multicast secondary ip address equals HexNumber
				ElementTypeTitle
				ElementTypeInstanceTitle
				end pdi configuration data                  { () }  

ElementTypeTitle : {- empty -}                              { () }  
			     | element type data
			       ElementTypeBody
				   end element type data                    { () }  

ElementTypeBody : {- empty -}                               { () }  
			    | ElementTypeBody ElementTypeInd            { () }  


ElementTypeInd : element type Number
				 type name equals namestring
				 status indication names
				 end status indication names
				 errortext indication names
				 end errortext indication names
				 FunctionsListTitle
				 end element type Number                    { () }  

FunctionsListTitle : {- empty -}                            { () }  
				   | function type list
				     FunctionsList
					 end function type list                 { () }  

FunctionsList : {- empty -}                                 { () }  
			  | FunctionsList FunctionsInd                  { () }  

FunctionsInd : function type Number
			   function name equals namestring
			   confirm equals Truth
			   text equals namestring
			   text id equals Number
			   text mne equals namestring
			   parameter name list
			   end parameter name list
			   end function type Number                     { () } 
			   
			   
ElementTypeInstanceTitle : {- empty -}                      { () }  
			             | element type instance data
			               ElementTypeInstanceBody
				           end element type instance data   { () } 
						   
ElementTypeInstanceBody : {- empty -}                                               { () }  
			            | ElementTypeInstanceBody ElementTypeInstanceInd            { () }  

ElementTypeInstanceInd : element type instance Number
						 element type ref equals Number
						 instance name equals namestring
						 sda equals namestring
						 mirror equals namestring
						 flt equals namestring
						 com flt equals namestring
						 accept equals namestring
						 reject equals namestring
						 marking equals namestring
						 status indications
						 end status indications
						 errortext indications
						 end errortext indications				         
				         end element type instance Number    { () }  


ModuleSOM : module som24 slot Number
            ModDec
			ModType at housing Number slot Number
			smb equals Number
			flashing dark periodtext equals Number
			flashing light periodtext equals Number
			antiphase flashing disabled equals Truth
			current proving group Number equals namestring
			current proving group Number equals namestring
			current proving group Number equals namestring
			current proving group Number equals namestring      			
			MonitorMne
			InputsSOM24
			OutputsSOM24	
			end module                                      { $55 }

Truth : truetext                                            { True }
      | falsetext                                           { False }

MonitorMne : start monitoring mnemonics 
             end monitoring mnemonics                       { () }

InputsSOM24 : start inputs
              InputSOM24
			  end inputs                                    { $3 }

InputSOM24 : {- empty -}                                    { []::VarMaps }
           | InputSOM24 InputIndSOM24                       { $2:$1 }

InputIndSOM24 : input Number
                high detection equals Number
				low detection equals Number
				zero holding disabled equals Truth
				positive input state equals namestring
				negative input state equals namestring      { ($20, False, ModSomInV)::VarMap }

OutputsSOM24 : start outputs
               OutputSOM24
			   end outputs                                  { $3 }

OutputSOM24 : {- empty -}                                   { []::VarMaps }
            | OutputSOM24 OutputIndSOM24                    { $2:$1 }

OutputIndSOM24 : output Number equals namestring
                 flashing equals namestring
				 current proving threshold equals Number
				 retained equals Truth
				 aws control equals namestring
				 current proving group equals Number        { ($4, False, ModSomOutV)::VarMap }





ReservedTimers : reserved timers ResTimerInfos
                 end reserved timers                        { $3 }

ResTimerInfos :                                             { []::VarMaps }
              | ResTimerInfos ResTimerInfo                  { $2 ++ $1 }

ResTimerInfo : timer trigger namestring access equals TAccessMode
               output namestring access equals TAccessMode
			   duration equals Duration setting equals SettingMode   { [($3,False, TimerInV)::VarMap, ($8,False, TimerOutV)::VarMap] }


TAccessMode : none                                          { () }
            | readtext                                      { () }

Duration : hyphen Duration2 TUnit                           { () }
         | Duration2 TUnit                                  { () }

Duration2 : Number period Number                            { ($1,$3) }
          | Number                                          { ($1,0) }

TUnit : hour                                                { () }
      | minute                                              { () }
      | second                                              { () }

SettingMode : fixed                                         { () }
            | default                                       { () }
            | user                                          { () }

UserTimers : user timers UsrTmrInfos end user timers        { $3 }

UsrTmrInfos :                                               { []::VarMaps }
            | UsrTmrInfos UsrTmrInfo                        { $2 ++ $1 }

UsrTmrInfo : timer Number equals trigger namestring 
             output namestring duration equals Duration        { [($5,False, TimerInV)::VarMap,
                                                               ($7,False, TimerOutV)::VarMap] }

NameSet : long namestring                                   { $2 }

FieldTimers : field timers FieldTmrInfos end field timers   { () }

FieldTmrInfos :                                             { () }
			  | FieldTmrInfos FieldTmrInfo                  { () }

FieldTmrInfo : none											{ () }

TimeOfDayTimers : time of day timers TodTmrInfos 
                  end time of day timers                    { () }

TodTmrInfos :                                               { () }
			| TodTmrInfos TodTmrInfo                        { () }

TodTmrInfo : none                                           { () }

SRLatches : sr latches 
            SRLatchInfos 
			end sr latches                                  { ($3) }

SRLatchInfos :                                              { []::SRLatchMaps }
             | SRLatchInfos SRLatchInfo                     { $2:$1 }

SRLatchInfo : latch Number equals 
              output namestring
              set namestring
              reset namestring                              { ($5, $7, $9)::SRLatchMap}

ReservedLatches : reserved latches
                  ResLatchInfos
                  end reserved latches                      { () }

ResLatchInfos :                                             { () }
              | ResLatchInfos ResLatchInfo                  { () }

ResLatchInfo : latch namestring access equals RAccessMode   { () }

RAccessMode : read                                          { () }
            | write                                         { () }
            | readwrite                                     { () }
            | none                                          { () }

UserLatches : user latches
              UsrLatchInfos
              end user latches                              { $3 }

UsrLatchInfos :                                             { []::VarMaps }
              | UsrLatchInfos UsrLatchInfo                  { $2:$1 }

UsrLatchInfo : latch Number equals namestring               { ($4,False, LatchV)::VarMap }


Inputs :                                                    { []::VarMaps }
       | Inputs Input                                       { $2:$1 }

Input : input Number equals NameSet 
initial state Number                                { ($4,int2bool $7, InputV)::VarMap }


Outputs :                                                   { []::VarMaps }
        | Outputs Output                                    { $2:$1 }

Output : output Number equals NameSet
initial state Number                               { ($4,int2bool $7,OutputV)::VarMap } 


Pair : yes                                                  { True }
     | no                                                   { False }

BooleanEquation : boolean equation end equation             { () }

RsasCheck : rsas end rsas                                   { () }

{

type VarMap = (String, Bool, VarType)
type SRLatchMap = (String, String, String)
type VarMaps = [VarMap]
type SRLatchMaps = [SRLatchMap]
data VarType = InputV | OutputV | LatchV | ReservedLatchV | TimerInV | TimerOutV | SRLatchV | ModPMPrimInV 
             | ModPMPrimOutV | ModSomInV | ModSomOutV

int2bool :: Int -> Bool
int2bool i = (i /= 0)

int2String :: Int -> String
int2String a = show a

happyError :: [Tokens] -> a
happyError ts = error "Parse Error"

} 
