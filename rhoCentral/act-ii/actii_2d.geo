SetFactory("OpenCASCADE");


size=0.0020;
blratio=4;
injectorfac=1;




If(Exists(size))
    basesize=size;
Else
    basesize=0.0002;
EndIf

If(Exists(blratio))
    boundratio=blratio;
Else
    boundratio=2.0;
EndIf

If(Exists(blratiocavity))
    boundratiocavity=blratiocavity;
Else
    boundratiocavity=2.0;
EndIf

If(Exists(blratioinjector))
    boundratioinjector=blratioinjector;
Else
    boundratioinjector=2.0;
EndIf

If(Exists(blratiosample))
    boundratiosample=blratiosample;
Else
    boundratiosample=4.0;
EndIf

If(Exists(blratiosurround))
    boundratiosurround=blratiosurround;
Else
    boundratiosurround=2.0;
EndIf

If(Exists(injectorfac))
    injector_factor=injectorfac;
Else
    injector_factor=10.0;
EndIf

// horizontal injection
cavityAngle=45;
inj_h=4.e-3;  // height of injector (bottom) from floor
inj_d=1.59e-3; // diameter of injector
inj_l = 20e-3; // length of injector

bigsize = basesize*4;     // the biggest mesh size 
inletsize = basesize*2;   // background mesh size upstream of the nozzle
isosize = basesize;       // background mesh size in the isolator
nozzlesize = basesize/2;       // background mesh size in the isolator
cavitysize = basesize/2.; // background mesh size in the cavity region
samplesize = basesize/2;       // background mesh size in the sample
injectorsize = inj_d/injector_factor; // background mesh size in the cavity region

Printf("basesize = %f", basesize);
Printf("inletsize = %f", inletsize);
Printf("isosize = %f", isosize);
Printf("nozzlesize = %f", nozzlesize);
Printf("cavitysize = %f", cavitysize);
Printf("injectorsize = %f", injectorsize);
Printf("samplesize = %f", samplesize);
Printf("boundratio = %f", boundratio);
Printf("boundratiocavity = %f", boundratiocavity);
Printf("boundratioinjector = %f", boundratioinjector);
Printf("boundratiosample = %f", boundratiosample);
Printf("boundratiosurround = %f", boundratiosurround);

p = 1;
l = 1;

//Top Wall
p_nozzle_top_start = p;
Point(p++) = {0.21,0.0270645,0.0,basesize};
Point(p++) = {0.2280392417062,0.0270645,0.0,basesize};
Point(p++) = {0.2287784834123,0.0270645,0.0,basesize};
Point(p++) = {0.2295177251185,0.0270645,0.0,basesize};
Point(p++) = {0.2302569668246,0.0270645,0.0,basesize};
Point(p++) = {0.2309962085308,0.0270645,0.0,basesize};
Point(p++) = {0.231735450237,0.0270645,0.0,basesize};
Point(p++) = {0.2324746919431,0.0270645,0.0,basesize};
Point(p++) = {0.2332139336493,0.0270645,0.0,basesize};
Point(p++) = {0.2339531753555,0.0270645,0.0,basesize};
Point(p++) = {0.2346924170616,0.02679523462424,0.0,basesize};
Point(p++) = {0.2354316587678,0.02628798808666,0.0,basesize};
Point(p++) = {0.2361709004739,0.02578074154909,0.0,basesize};
Point(p++) = {0.2369101421801,0.02527349501151,0.0,basesize};
Point(p++) = {0.2376493838863,0.02476624847393,0.0,basesize};
Point(p++) = {0.2383886255924,0.02425900193636,0.0,basesize};
Point(p++) = {0.2391278672986,0.02375175539878,0.0,basesize};
Point(p++) = {0.2398671090047,0.02324450886121,0.0,basesize};
Point(p++) = {0.2406063507109,0.02273726232363,0.0,basesize};
Point(p++) = {0.2413455924171,0.02223001578605,0.0,basesize};
Point(p++) = {0.2420848341232,0.02172276924848,0.0,basesize};
Point(p++) = {0.2428240758294,0.0212155227109,0.0,basesize};
Point(p++) = {0.2435633175355,0.02070827617332,0.0,basesize};
Point(p++) = {0.2443025592417,0.02020102963575,0.0,basesize};
Point(p++) = {0.2450418009479,0.01969378309817,0.0,basesize};
Point(p++) = {0.245781042654,0.0191865365606,0.0,basesize};
Point(p++) = {0.2465202843602,0.01867929002302,0.0,basesize};
Point(p++) = {0.2472595260664,0.01817204348544,0.0,basesize};
Point(p++) = {0.2479987677725,0.01766479694787,0.0,basesize};
Point(p++) = {0.2487380094787,0.01715755041029,0.0,basesize};
Point(p++) = {0.2494772511848,0.01665030387271,0.0,basesize};
Point(p++) = {0.250216492891,0.01614305733514,0.0,basesize};
Point(p++) = {0.2509557345972,0.01563581079756,0.0,basesize};
Point(p++) = {0.2516949763033,0.01512856425999,0.0,basesize};
Point(p++) = {0.2524342180095,0.01462131772241,0.0,basesize};
Point(p++) = {0.2531734597156,0.01411407118483,0.0,basesize};
Point(p++) = {0.2539127014218,0.01360682464726,0.0,basesize};
Point(p++) = {0.254651943128,0.01309957810968,0.0,basesize};
Point(p++) = {0.2553911848341,0.01259233157211,0.0,basesize};
Point(p++) = {0.2561304265403,0.01208508503453,0.0,basesize};
Point(p++) = {0.2568696682464,0.01157783849695,0.0,basesize};
Point(p++) = {0.2576089099526,0.01107059195938,0.0,basesize};
Point(p++) = {0.2583481516588,0.0105633454218,0.0,basesize};
Point(p++) = {0.2590873933649,0.01005609888422,0.0,basesize};
Point(p++) = {0.2598266350711,0.009548852346649,0.0,basesize};
Point(p++) = {0.2605658767773,0.009041605809072,0.0,basesize};
Point(p++) = {0.2613051184834,0.008534359271496,0.0,basesize};
Point(p++) = {0.2620443601896,0.00802711273392,0.0,basesize};
Point(p++) = {0.2627836018957,0.007519866196344,0.0,basesize};
Point(p++) = {0.2635228436019,0.007012619658768,0.0,basesize};
Point(p++) = {0.2642620853081,0.006505373121192,0.0,basesize};
Point(p++) = {0.2650013270142,0.005998126583615,0.0,basesize};
Point(p++) = {0.2657405687204,0.005490880046039,0.0,basesize};
Point(p++) = {0.2664798104265,0.004983633508463,0.0,basesize};
Point(p++) = {0.2672190521327,0.004476386970887,0.0,basesize};
Point(p++) = {0.2679582938389,0.003969140433311,0.0,basesize};
Point(p++) = {0.268697535545,0.003461893895735,0.0,basesize};
Point(p++) = {0.2694367772512,0.002954647358158,0.0,basesize};
Point(p++) = {0.2701760189573,0.002447400820582,0.0,basesize};
Point(p++) = {0.2709152606635,0.001940154283006,0.0,basesize};
Point(p++) = {0.2716545023697,0.00143290774543,0.0,basesize};
Point(p++) = {0.2723937440758,0.0009256612078538,0.0,basesize};
Point(p++) = {0.273132985782,0.0004184146702776,0.0,basesize};
Point(p++) = {0.2738722274882,-8.883186729857e-05,0.0,basesize};
Point(p++) = {0.2746114691943,-0.0005960784048747,0.0,basesize};
Point(p++) = {0.2753507109005,-0.001103324942451,0.0,basesize};
Point(p++) = {0.2760899526066,-0.001610571480027,0.0,basesize};
Point(p++) = {0.2768291943128,-0.0021178180176,0.0,basesize};
Point(p++) = {0.277568436019,-0.002625063418531,0.0,basesize};
Point(p++) = {0.2783076777251,-0.003128071371827,0.0,basesize};
Point(p++) = {0.2790469194313,-0.00356543025825,0.0,basesize};
Point(p++) = {0.2797861611374,-0.003924485596916,0.0,basesize};
Point(p++) = {0.2805254028436,-0.004209800511799,0.0,basesize};
Point(p++) = {0.2812646445498,-0.004425962626834,0.0,basesize};
Point(p++) = {0.2820038862559,-0.004577559566121,0.0,basesize};
Point(p++) = {0.2827431279621,-0.004669178953759,0.0,basesize};
Point(p++) = {0.2834823696682,-0.004705408413847,0.0,basesize};
Point(p++) = {0.2842216113744,-0.004697204954745,0.0,basesize};
Point(p++) = {0.2849608530806,-0.00465704436755,0.0,basesize};
Point(p++) = {0.2857000947867,-0.004586244418798,0.0,basesize};
Point(p++) = {0.2864393364929,-0.004485025473862,0.0,basesize};
Point(p++) = {0.2871785781991,-0.004353607898117,0.0,basesize};
Point(p++) = {0.2879178199052,-0.004192212056935,0.0,basesize};
Point(p++) = {0.2886570616114,-0.00400105831569,0.0,basesize};
Point(p++) = {0.2893963033175,-0.003780367039754,0.0,basesize};
Point(p++) = {0.2901355450237,-0.003530358594502,0.0,basesize};
Point(p++) = {0.2908747867299,-0.003251253345306,0.0,basesize};
Point(p++) = {0.291614028436,-0.002943271657539,0.0,basesize};
Point(p++) = {0.2923532701422,-0.002613060084159,0.0,basesize};
Point(p++) = {0.2930925118483,-0.00228623916318,0.0,basesize};
Point(p++) = {0.2938317535545,-0.001965379671836,0.0,basesize};
Point(p++) = {0.2945709952607,-0.001650408524638,0.0,basesize};
Point(p++) = {0.2953102369668,-0.001341252636095,0.0,basesize};
Point(p++) = {0.296049478673,-0.001037838920719,0.0,basesize};
Point(p++) = {0.2967887203791,-0.0007400942930211,0.0,basesize};
Point(p++) = {0.2975279620853,-0.0004479456675107,0.0,basesize};
Point(p++) = {0.2982672037915,-0.0001613199586989,0.0,basesize};
Point(p++) = {0.2990064454976,0.0001198559189035,0.0,basesize};
Point(p++) = {0.2997456872038,0.0003956550507858,0.0,basesize};
Point(p++) = {0.30048492891,0.0006661505224375,0.0,basesize};
Point(p++) = {0.3012241706161,0.0009314154193479,0.0,basesize};
Point(p++) = {0.3019634123223,0.001191522827006,0.0,basesize};
Point(p++) = {0.3027026540284,0.001446545830902,0.0,basesize};
Point(p++) = {0.3034418957346,0.001696557516524,0.0,basesize};
Point(p++) = {0.3041811374408,0.001941630969363,0.0,basesize};
Point(p++) = {0.3049203791469,0.002181839274906,0.0,basesize};
Point(p++) = {0.3056596208531,0.002417255518644,0.0,basesize};
Point(p++) = {0.3063988625592,0.002647952786067,0.0,basesize};
Point(p++) = {0.3071381042654,0.002874004162662,0.0,basesize};
Point(p++) = {0.3078773459716,0.003095482733921,0.0,basesize};
Point(p++) = {0.3086165876777,0.003312461585331,0.0,basesize};
Point(p++) = {0.3093558293839,0.003525013802383,0.0,basesize};
Point(p++) = {0.31009507109,0.003733212470565,0.0,basesize};
Point(p++) = {0.3108343127962,0.003937130675367,0.0,basesize};
Point(p++) = {0.3115735545024,0.004136841502279,0.0,basesize};
Point(p++) = {0.3123127962085,0.004332418036789,0.0,basesize};
Point(p++) = {0.3130520379147,0.004523933364387,0.0,basesize};
Point(p++) = {0.3137912796209,0.004711460570563,0.0,basesize};
Point(p++) = {0.314530521327,0.004895072740805,0.0,basesize};
Point(p++) = {0.3152697630332,0.005074842960603,0.0,basesize};
Point(p++) = {0.3160090047393,0.005250844315447,0.0,basesize};
Point(p++) = {0.3167482464455,0.005423149890825,0.0,basesize};
Point(p++) = {0.3174874881517,0.005591832772228,0.0,basesize};
Point(p++) = {0.3182267298578,0.005756966045143,0.0,basesize};
Point(p++) = {0.318965971564,0.005918622795062,0.0,basesize};
Point(p++) = {0.3197052132701,0.006076876107472,0.0,basesize};
Point(p++) = {0.3204444549763,0.006231799067864,0.0,basesize};
Point(p++) = {0.3211836966825,0.006383464761726,0.0,basesize};
Point(p++) = {0.3219229383886,0.006531946274548,0.0,basesize};
Point(p++) = {0.3226621800948,0.00667731669182,0.0,basesize};
Point(p++) = {0.3234014218009,0.00681964909903,0.0,basesize};
Point(p++) = {0.3241406635071,0.006959016581669,0.0,basesize};
Point(p++) = {0.3248799052133,0.007095492225225,0.0,basesize};
Point(p++) = {0.3256191469194,0.007229149115187,0.0,basesize};
Point(p++) = {0.3263583886256,0.007360060337045,0.0,basesize};
Point(p++) = {0.3270976303318,0.007488298976289,0.0,basesize};
Point(p++) = {0.3278368720379,0.007613938118408,0.0,basesize};
Point(p++) = {0.3285761137441,0.00773705084889,0.0,basesize};
Point(p++) = {0.3293153554502,0.007857710253226,0.0,basesize};
Point(p++) = {0.3300545971564,0.007975989416904,0.0,basesize};
Point(p++) = {0.3307938388626,0.008091961425415,0.0,basesize};
Point(p++) = {0.3315330805687,0.008205699364247,0.0,basesize};
Point(p++) = {0.3322723222749,0.008317276318889,0.0,basesize};
Point(p++) = {0.333011563981,0.008426765374832,0.0,basesize};
Point(p++) = {0.3337508056872,0.008534231284918,0.0,basesize};
Point(p++) = {0.3344900473934,0.008639591517526,0.0,basesize};
Point(p++) = {0.3352292890995,0.008742817528548,0.0,basesize};
Point(p++) = {0.3359685308057,0.008843926036179,0.0,basesize};
Point(p++) = {0.3367077725118,0.008942933758618,0.0,basesize};
Point(p++) = {0.337447014218,0.009039857414062,0.0,basesize};
Point(p++) = {0.3381862559242,0.00913471372071,0.0,basesize};
Point(p++) = {0.3389254976303,0.009227519396758,0.0,basesize};
Point(p++) = {0.3396647393365,0.009318291160404,0.0,basesize};
Point(p++) = {0.3404039810427,0.009407045729847,0.0,basesize};
Point(p++) = {0.3411432227488,0.009493799823283,0.0,basesize};
Point(p++) = {0.341882464455,0.00957857015891,0.0,basesize};
Point(p++) = {0.3426217061611,0.009661373454925,0.0,basesize};
Point(p++) = {0.3433609478673,0.009742226429528,0.0,basesize};
Point(p++) = {0.3441001895735,0.009821145800914,0.0,basesize};
Point(p++) = {0.3448394312796,0.009898148287282,0.0,basesize};
Point(p++) = {0.3455786729858,0.00997325060683,0.0,basesize};
Point(p++) = {0.3463179146919,0.01004646947775,0.0,basesize};
Point(p++) = {0.3470571563981,0.01011782161825,0.0,basesize};
Point(p++) = {0.3477963981043,0.01018732374652,0.0,basesize};
Point(p++) = {0.3485356398104,0.01025499258077,0.0,basesize};
Point(p++) = {0.3492748815166,0.01032084483917,0.0,basesize};
Point(p++) = {0.3500141232227,0.01038489723995,0.0,basesize};
Point(p++) = {0.3507533649289,0.01044716650128,0.0,basesize};
Point(p++) = {0.3514926066351,0.01050766934138,0.0,basesize};
Point(p++) = {0.3522318483412,0.01056642247844,0.0,basesize};
Point(p++) = {0.3529710900474,0.01062344263065,0.0,basesize};
Point(p++) = {0.3537103317536,0.01067874651621,0.0,basesize};
Point(p++) = {0.3544495734597,0.01073235085333,0.0,basesize};
Point(p++) = {0.3551888151659,0.01078427236019,0.0,basesize};
Point(p++) = {0.355928056872,0.010834527755,0.0,basesize};
Point(p++) = {0.3566672985782,0.01088313375595,0.0,basesize};
Point(p++) = {0.3574065402844,0.01093010708125,0.0,basesize};
Point(p++) = {0.3581457819905,0.01097546444908,0.0,basesize};
Point(p++) = {0.3588850236967,0.01101922257765,0.0,basesize};
Point(p++) = {0.3596242654028,0.01106139818516,0.0,basesize};
Point(p++) = {0.360363507109,0.0111020079898,0.0,basesize};
Point(p++) = {0.3611027488152,0.01114106870976,0.0,basesize};
Point(p++) = {0.3618419905213,0.01117859706326,0.0,basesize};
Point(p++) = {0.3625812322275,0.01121460976848,0.0,basesize};
Point(p++) = {0.3633204739336,0.01124912354362,0.0,basesize};
Point(p++) = {0.3640597156398,0.01128215510688,0.0,basesize};
Point(p++) = {0.364798957346,0.01131372117646,0.0,basesize};
Point(p++) = {0.3655381990521,0.01134383847056,0.0,basesize};
Point(p++) = {0.3662774407583,0.01137252370737,0.0,basesize};
Point(p++) = {0.3670166824645,0.01139979360508,0.0,basesize};
Point(p++) = {0.3677559241706,0.01142566488191,0.0,basesize};
Point(p++) = {0.3684951658768,0.01145015425605,0.0,basesize};
Point(p++) = {0.3692344075829,0.01147327844568,0.0,basesize};
Point(p++) = {0.3699736492891,0.01149505416902,0.0,basesize};
Point(p++) = {0.3707128909953,0.01151549814426,0.0,basesize};
Point(p++) = {0.3714521327014,0.01153462708959,0.0,basesize};
Point(p++) = {0.3721913744076,0.01155245772322,0.0,basesize};
Point(p++) = {0.3729306161137,0.01156900676334,0.0,basesize};
Point(p++) = {0.3736698578199,0.01158429092815,0.0,basesize};
Point(p++) = {0.3744090995261,0.01159832693585,0.0,basesize};
Point(p++) = {0.3751483412322,0.01161113150463,0.0,basesize};
Point(p++) = {0.3758875829384,0.01162272135269,0.0,basesize};
Point(p++) = {0.3766268246445,0.01163311319823,0.0,basesize};
Point(p++) = {0.3773660663507,0.01164232375945,0.0,basesize};
Point(p++) = {0.3781053080569,0.01165036975455,0.0,basesize};
Point(p++) = {0.378844549763,0.01165726790172,0.0,basesize};
Point(p++) = {0.3795837914692,0.01166303491916,0.0,basesize};
Point(p++) = {0.3803230331754,0.01166768752507,0.0,basesize};
Point(p++) = {0.3810622748815,0.01167124243764,0.0,basesize};
Point(p++) = {0.3818015165877,0.01167371637508,0.0,basesize};
Point(p++) = {0.3825407582938,0.01167512605558,0.0,basesize};
Point(p++) = {0.38328,0.01167548819733,0.0,basesize};
p_nozzle_top_end = p-1;

//Bottom Wall
p_nozzle_bottom_start = p;
Point(p++) = {0.21,-0.0270645,0.0,basesize};
Point(p++) = {0.2280392417062,-0.0270645,0.0,basesize};
Point(p++) = {0.2287784834123,-0.0270645,0.0,basesize};
Point(p++) = {0.2295177251185,-0.0270645,0.0,basesize};
Point(p++) = {0.2302569668246,-0.0270645,0.0,basesize};
Point(p++) = {0.2309962085308,-0.0270645,0.0,basesize};
Point(p++) = {0.231735450237,-0.0270645,0.0,basesize};
Point(p++) = {0.2324746919431,-0.0270645,0.0,basesize};
Point(p++) = {0.2332139336493,-0.0270645,0.0,basesize};
Point(p++) = {0.2339531753555,-0.0270645,0.0,basesize};
Point(p++) = {0.2346924170616,-0.02679430246686,0.0,basesize};
Point(p++) = {0.2354316587678,-0.0262852999159,0.0,basesize};
Point(p++) = {0.2361709004739,-0.02577629736494,0.0,basesize};
Point(p++) = {0.2369101421801,-0.02526729481398,0.0,basesize};
Point(p++) = {0.2376493838863,-0.02475829226302,0.0,basesize};
Point(p++) = {0.2383886255924,-0.02424928971206,0.0,basesize};
Point(p++) = {0.2391278672986,-0.0237402871611,0.0,basesize};
Point(p++) = {0.2398671090047,-0.02323128461014,0.0,basesize};
Point(p++) = {0.2406063507109,-0.02272228205918,0.0,basesize};
Point(p++) = {0.2413455924171,-0.02221327950822,0.0,basesize};
Point(p++) = {0.2420848341232,-0.02170427695726,0.0,basesize};
Point(p++) = {0.2428240758294,-0.0211952744063,0.0,basesize};
Point(p++) = {0.2435633175355,-0.02068627185534,0.0,basesize};
Point(p++) = {0.2443025592417,-0.02017726930438,0.0,basesize};
Point(p++) = {0.2450418009479,-0.01966826675342,0.0,basesize};
Point(p++) = {0.245781042654,-0.01915926420245,0.0,basesize};
Point(p++) = {0.2465202843602,-0.01865026165149,0.0,basesize};
Point(p++) = {0.2472595260664,-0.01814125910053,0.0,basesize};
Point(p++) = {0.2479987677725,-0.01763225654957,0.0,basesize};
Point(p++) = {0.2487380094787,-0.01712325399861,0.0,basesize};
Point(p++) = {0.2494772511848,-0.01661425144765,0.0,basesize};
Point(p++) = {0.250216492891,-0.01610524889669,0.0,basesize};
Point(p++) = {0.2509557345972,-0.01559624634573,0.0,basesize};
Point(p++) = {0.2516949763033,-0.01508724379477,0.0,basesize};
Point(p++) = {0.2524342180095,-0.01457824124381,0.0,basesize};
Point(p++) = {0.2531734597156,-0.01406923869285,0.0,basesize};
Point(p++) = {0.2539127014218,-0.01356023614189,0.0,basesize};
Point(p++) = {0.254651943128,-0.01305123359093,0.0,basesize};
Point(p++) = {0.2553911848341,-0.01254223104006,0.0,basesize};
Point(p++) = {0.2561304265403,-0.01203324300793,0.0,basesize};
Point(p++) = {0.2568696682464,-0.01153323105766,0.0,basesize};
Point(p++) = {0.2576089099526,-0.01107308263704,0.0,basesize};
Point(p++) = {0.2583481516588,-0.01065403753526,0.0,basesize};
Point(p++) = {0.2590873933649,-0.0102747284778,0.0,basesize};
Point(p++) = {0.2598266350711,-0.009933787576145,0.0,basesize};
Point(p++) = {0.2605658767773,-0.009629846941815,0.0,basesize};
Point(p++) = {0.2613051184834,-0.009361538686311,0.0,basesize};
Point(p++) = {0.2620443601896,-0.009127494921139,0.0,basesize};
Point(p++) = {0.2627836018957,-0.008926347757803,0.0,basesize};
Point(p++) = {0.2635228436019,-0.008756729307808,0.0,basesize};
Point(p++) = {0.2642620853081,-0.008617271682661,0.0,basesize};
Point(p++) = {0.2650013270142,-0.008506606993866,0.0,basesize};
Point(p++) = {0.2657405687204,-0.008423367352927,0.0,basesize};
Point(p++) = {0.2664798104265,-0.008366184871351,0.0,basesize};
Point(p++) = {0.2672190521327,-0.008333691646977,0.0,basesize};
Point(p++) = {0.2679582938389,-0.008324504031647,0.0,basesize};
Point(p++) = {0.268697535545,-0.008324500001239,0.0,basesize};
Point(p++) = {0.2694367772512,-0.0083245,0.0,basesize};
Point(p++) = {0.2701760189573,-0.0083245,0.0,basesize};
Point(p++) = {0.2709152606635,-0.0083245,0.0,basesize};
Point(p++) = {0.2716545023697,-0.0083245,0.0,basesize};
Point(p++) = {0.2723937440758,-0.0083245,0.0,basesize};
Point(p++) = {0.273132985782,-0.0083245,0.0,basesize};
Point(p++) = {0.2738722274882,-0.0083245,0.0,basesize};
Point(p++) = {0.2746114691943,-0.0083245,0.0,basesize};
Point(p++) = {0.2753507109005,-0.0083245,0.0,basesize};
Point(p++) = {0.2760899526066,-0.0083245,0.0,basesize};
Point(p++) = {0.2768291943128,-0.0083245,0.0,basesize};
Point(p++) = {0.277568436019,-0.0083245,0.0,basesize};
Point(p++) = {0.2783076777251,-0.0083245,0.0,basesize};
Point(p++) = {0.2790469194313,-0.0083245,0.0,basesize};
Point(p++) = {0.2797861611374,-0.0083245,0.0,basesize};
Point(p++) = {0.2805254028436,-0.0083245,0.0,basesize};
Point(p++) = {0.2812646445498,-0.0083245,0.0,basesize};
Point(p++) = {0.2820038862559,-0.0083245,0.0,basesize};
Point(p++) = {0.2827431279621,-0.0083245,0.0,basesize};
Point(p++) = {0.2834823696682,-0.0083245,0.0,basesize};
Point(p++) = {0.2842216113744,-0.0083245,0.0,basesize};
Point(p++) = {0.2849608530806,-0.0083245,0.0,basesize};
Point(p++) = {0.2857000947867,-0.0083245,0.0,basesize};
Point(p++) = {0.2864393364929,-0.0083245,0.0,basesize};
Point(p++) = {0.2871785781991,-0.0083245,0.0,basesize};
Point(p++) = {0.2879178199052,-0.0083245,0.0,basesize};
Point(p++) = {0.2886570616114,-0.0083245,0.0,basesize};
Point(p++) = {0.2893963033175,-0.0083245,0.0,basesize};
Point(p++) = {0.2901355450237,-0.0083245,0.0,basesize};
Point(p++) = {0.2908747867299,-0.0083245,0.0,basesize};
Point(p++) = {0.291614028436,-0.0083245,0.0,basesize};
Point(p++) = {0.2923532701422,-0.0083245,0.0,basesize};
Point(p++) = {0.2930925118483,-0.0083245,0.0,basesize};
Point(p++) = {0.2938317535545,-0.0083245,0.0,basesize};
Point(p++) = {0.2945709952607,-0.0083245,0.0,basesize};
Point(p++) = {0.2953102369668,-0.0083245,0.0,basesize};
Point(p++) = {0.296049478673,-0.0083245,0.0,basesize};
Point(p++) = {0.2967887203791,-0.0083245,0.0,basesize};
Point(p++) = {0.2975279620853,-0.0083245,0.0,basesize};
Point(p++) = {0.2982672037915,-0.0083245,0.0,basesize};
Point(p++) = {0.2990064454976,-0.0083245,0.0,basesize};
Point(p++) = {0.2997456872038,-0.0083245,0.0,basesize};
Point(p++) = {0.30048492891,-0.0083245,0.0,basesize};
Point(p++) = {0.3012241706161,-0.0083245,0.0,basesize};
Point(p++) = {0.3019634123223,-0.0083245,0.0,basesize};
Point(p++) = {0.3027026540284,-0.0083245,0.0,basesize};
Point(p++) = {0.3034418957346,-0.0083245,0.0,basesize};
Point(p++) = {0.3041811374408,-0.0083245,0.0,basesize};
Point(p++) = {0.3049203791469,-0.0083245,0.0,basesize};
Point(p++) = {0.3056596208531,-0.0083245,0.0,basesize};
Point(p++) = {0.3063988625592,-0.0083245,0.0,basesize};
Point(p++) = {0.3071381042654,-0.0083245,0.0,basesize};
Point(p++) = {0.3078773459716,-0.0083245,0.0,basesize};
Point(p++) = {0.3086165876777,-0.0083245,0.0,basesize};
Point(p++) = {0.3093558293839,-0.0083245,0.0,basesize};
Point(p++) = {0.31009507109,-0.0083245,0.0,basesize};
Point(p++) = {0.3108343127962,-0.0083245,0.0,basesize};
Point(p++) = {0.3115735545024,-0.0083245,0.0,basesize};
Point(p++) = {0.3123127962085,-0.0083245,0.0,basesize};
Point(p++) = {0.3130520379147,-0.0083245,0.0,basesize};
Point(p++) = {0.3137912796209,-0.0083245,0.0,basesize};
Point(p++) = {0.314530521327,-0.0083245,0.0,basesize};
Point(p++) = {0.3152697630332,-0.0083245,0.0,basesize};
Point(p++) = {0.3160090047393,-0.0083245,0.0,basesize};
Point(p++) = {0.3167482464455,-0.0083245,0.0,basesize};
Point(p++) = {0.3174874881517,-0.0083245,0.0,basesize};
Point(p++) = {0.3182267298578,-0.0083245,0.0,basesize};
Point(p++) = {0.318965971564,-0.0083245,0.0,basesize};
Point(p++) = {0.3197052132701,-0.0083245,0.0,basesize};
Point(p++) = {0.3204444549763,-0.0083245,0.0,basesize};
Point(p++) = {0.3211836966825,-0.0083245,0.0,basesize};
Point(p++) = {0.3219229383886,-0.0083245,0.0,basesize};
Point(p++) = {0.3226621800948,-0.0083245,0.0,basesize};
Point(p++) = {0.3234014218009,-0.0083245,0.0,basesize};
Point(p++) = {0.3241406635071,-0.0083245,0.0,basesize};
Point(p++) = {0.3248799052133,-0.0083245,0.0,basesize};
Point(p++) = {0.3256191469194,-0.0083245,0.0,basesize};
Point(p++) = {0.3263583886256,-0.0083245,0.0,basesize};
Point(p++) = {0.3270976303318,-0.0083245,0.0,basesize};
Point(p++) = {0.3278368720379,-0.0083245,0.0,basesize};
Point(p++) = {0.3285761137441,-0.0083245,0.0,basesize};
Point(p++) = {0.3293153554502,-0.0083245,0.0,basesize};
Point(p++) = {0.3300545971564,-0.0083245,0.0,basesize};
Point(p++) = {0.3307938388626,-0.0083245,0.0,basesize};
Point(p++) = {0.3315330805687,-0.0083245,0.0,basesize};
Point(p++) = {0.3322723222749,-0.0083245,0.0,basesize};
Point(p++) = {0.333011563981,-0.0083245,0.0,basesize};
Point(p++) = {0.3337508056872,-0.0083245,0.0,basesize};
Point(p++) = {0.3344900473934,-0.0083245,0.0,basesize};
Point(p++) = {0.3352292890995,-0.0083245,0.0,basesize};
Point(p++) = {0.3359685308057,-0.0083245,0.0,basesize};
Point(p++) = {0.3367077725118,-0.0083245,0.0,basesize};
Point(p++) = {0.337447014218,-0.0083245,0.0,basesize};
Point(p++) = {0.3381862559242,-0.0083245,0.0,basesize};
Point(p++) = {0.3389254976303,-0.0083245,0.0,basesize};
Point(p++) = {0.3396647393365,-0.0083245,0.0,basesize};
Point(p++) = {0.3404039810427,-0.0083245,0.0,basesize};
Point(p++) = {0.3411432227488,-0.0083245,0.0,basesize};
Point(p++) = {0.341882464455,-0.0083245,0.0,basesize};
Point(p++) = {0.3426217061611,-0.0083245,0.0,basesize};
Point(p++) = {0.3433609478673,-0.0083245,0.0,basesize};
Point(p++) = {0.3441001895735,-0.0083245,0.0,basesize};
Point(p++) = {0.3448394312796,-0.0083245,0.0,basesize};
Point(p++) = {0.3455786729858,-0.0083245,0.0,basesize};
Point(p++) = {0.3463179146919,-0.0083245,0.0,basesize};
Point(p++) = {0.3470571563981,-0.0083245,0.0,basesize};
Point(p++) = {0.3477963981043,-0.0083245,0.0,basesize};
Point(p++) = {0.3485356398104,-0.0083245,0.0,basesize};
Point(p++) = {0.3492748815166,-0.0083245,0.0,basesize};
Point(p++) = {0.3500141232227,-0.0083245,0.0,basesize};
Point(p++) = {0.3507533649289,-0.0083245,0.0,basesize};
Point(p++) = {0.3514926066351,-0.0083245,0.0,basesize};
Point(p++) = {0.3522318483412,-0.0083245,0.0,basesize};
Point(p++) = {0.3529710900474,-0.0083245,0.0,basesize};
Point(p++) = {0.3537103317536,-0.0083245,0.0,basesize};
Point(p++) = {0.3544495734597,-0.0083245,0.0,basesize};
Point(p++) = {0.3551888151659,-0.0083245,0.0,basesize};
Point(p++) = {0.355928056872,-0.0083245,0.0,basesize};
Point(p++) = {0.3566672985782,-0.0083245,0.0,basesize};
Point(p++) = {0.3574065402844,-0.0083245,0.0,basesize};
Point(p++) = {0.3581457819905,-0.0083245,0.0,basesize};
Point(p++) = {0.3588850236967,-0.0083245,0.0,basesize};
Point(p++) = {0.3596242654028,-0.0083245,0.0,basesize};
Point(p++) = {0.360363507109,-0.0083245,0.0,basesize};
Point(p++) = {0.3611027488152,-0.0083245,0.0,basesize};
Point(p++) = {0.3618419905213,-0.0083245,0.0,basesize};
Point(p++) = {0.3625812322275,-0.0083245,0.0,basesize};
Point(p++) = {0.3633204739336,-0.0083245,0.0,basesize};
Point(p++) = {0.3640597156398,-0.0083245,0.0,basesize};
Point(p++) = {0.364798957346,-0.0083245,0.0,basesize};
Point(p++) = {0.3655381990521,-0.0083245,0.0,basesize};
Point(p++) = {0.3662774407583,-0.0083245,0.0,basesize};
Point(p++) = {0.3670166824645,-0.0083245,0.0,basesize};
Point(p++) = {0.3677559241706,-0.0083245,0.0,basesize};
Point(p++) = {0.3684951658768,-0.0083245,0.0,basesize};
Point(p++) = {0.3692344075829,-0.0083245,0.0,basesize};
Point(p++) = {0.3699736492891,-0.0083245,0.0,basesize};
Point(p++) = {0.3707128909953,-0.0083245,0.0,basesize};
Point(p++) = {0.3714521327014,-0.0083245,0.0,basesize};
Point(p++) = {0.3721913744076,-0.0083245,0.0,basesize};
Point(p++) = {0.3729306161137,-0.0083245,0.0,basesize};
Point(p++) = {0.3736698578199,-0.0083245,0.0,basesize};
Point(p++) = {0.3744090995261,-0.0083245,0.0,basesize};
Point(p++) = {0.3751483412322,-0.0083245,0.0,basesize};
Point(p++) = {0.3758875829384,-0.0083245,0.0,basesize};
Point(p++) = {0.3766268246445,-0.0083245,0.0,basesize};
Point(p++) = {0.3773660663507,-0.0083245,0.0,basesize};
Point(p++) = {0.3781053080569,-0.0083245,0.0,basesize};
Point(p++) = {0.378844549763,-0.0083245,0.0,basesize};
Point(p++) = {0.3795837914692,-0.0083245,0.0,basesize};
Point(p++) = {0.3803230331754,-0.0083245,0.0,basesize};
Point(p++) = {0.3810622748815,-0.0083245,0.0,basesize};
Point(p++) = {0.3818015165877,-0.0083245,0.0,basesize};
Point(p++) = {0.38328,-0.0083245,0.0,basesize};
p_nozzle_bottom_end = p-1;

//Make Lines
//Top
l_nozzle_top = l++;
Spline(l_nozzle_top) = {p_nozzle_top_start:p_nozzle_top_end};  // goes clockwise

//Bottom Lines
l_nozzle_bottom = l++;
Spline(l_nozzle_bottom) = {p_nozzle_bottom_start:p_nozzle_bottom_end}; // goes counter-clockwise

//Mid-point on inlet
p_inlet_midpoint = p++;
Point(p_inlet_midpoint) = {0.21, (0.0270645-0.0270645)/2.,0.0,2*basesize};
//Inlet
l_inlet = l++;
Line(l_inlet) = {p_nozzle_top_start,p_nozzle_bottom_start};  //goes counter-clockwise

//Cavity Start
p_cavity_front_upper = p++;
Point(p_cavity_front_upper) = {0.65163,-0.0083245,0.0,basesize};

//Bottom of cavity
x_cavity_rl = 0.70163;
x_cavity_ru = x_cavity_rl + 0.02;
y_cavity_l = -0.0283245;
y_cavity_u = -0.0083245;
p_cavity_front_lower = p++;
p_cavity_rear_lower = p++;
p_cavity_rear_upper = p++;
p_expansion_start = p++;
Point(p_cavity_front_lower) = {0.65163,y_cavity_l,0.0,basesize};
Point(p_cavity_rear_lower) = {x_cavity_rl,y_cavity_l,0.0,basesize};
Point(p_cavity_rear_upper) = {x_cavity_ru,y_cavity_u,0.0,basesize};
Point(p_expansion_start) = {x_cavity_ru+0.02,y_cavity_u,0.0,basesize};

// injector
p_injector_cavity_lower = p++;
p_injector_cavity_upper = p++;
p_injector_entrance_lower = p++;
p_injector_entrance_upper = p++;
Point(p_injector_cavity_lower) = {x_cavity_rl+inj_h, y_cavity_l+inj_h, 0., basesize};
Point(p_injector_entrance_lower) = {x_cavity_rl+inj_h+inj_l, y_cavity_l+inj_h, 0., basesize};
Point(p_injector_entrance_upper) = {x_cavity_rl+inj_h+inj_l, y_cavity_l+inj_h+inj_d, 0., basesize};
Point(p_injector_cavity_upper) = {x_cavity_rl+inj_h+inj_d, y_cavity_l+inj_h+inj_d, 0., basesize};

//Wall
p_wall_insert_front_lower = p++;
p_wall_insert_front_upper = p++;
p_wall_insert_rear_lower = p++;
p_wall_insert_rear_upper = p++;
p_wall_surround_front_lower = p++;
p_wall_surround_rear_lower = p++;
Point(p_wall_insert_front_lower) = {x_cavity_ru-0.01,y_cavity_u-0.012,0.0,basesize};
Point(p_wall_insert_front_upper) = {x_cavity_ru-0.01,y_cavity_u-0.01,0.0,basesize};
Point(p_wall_insert_rear_lower) = {x_cavity_ru+0.01,y_cavity_u-0.012,0.0,basesize};
Point(p_wall_insert_rear_upper) = {x_cavity_ru+0.01,y_cavity_u,0.0,basesize};
Point(p_wall_surround_front_lower) = {x_cavity_ru-0.014,y_cavity_u-0.014,0.0,basesize};
Point(p_wall_surround_rear_lower) = {x_cavity_ru+0.02,y_cavity_u-0.014,0.0,basesize};

//Extend downstream a bit
p_outlet_lower = p++;
p_outlet_upper = p++;
Point(p_outlet_lower) = {0.65163+0.335,-0.008324-(0.265-0.02)*Sin(2*Pi/180),0.0,basesize};
Point(p_outlet_upper) = {0.65163+0.335,0.01167548819733,0.0,basesize};

//Make Cavity lines
l_isolator_to_cavity = l++;
l_cavity_front = l++;
l_cavity_bottom = l++;
l_cavity_rear_1 = l++;
l_cavity_rear_2 = l++;
l_cavity_rear_3 = l++;
l_cavity_rear_4 = l++;
l_postcavity_flat_1 = l++;
l_postcavity_flat_2 = l++;
l_bottom_expansion = l++;
l_wall_insert_front = l++;
l_wall_insert_bottom = l++;
l_wall_insert_rear = l++;
l_wall_surround_bottom = l++;
l_wall_surround_rear = l++;
l_bottom_expansion = l++;
l_injector_bottom = l++;
l_injector_inlet = l++;
l_injector_top = l++;
Line(l_isolator_to_cavity) = {p_nozzle_bottom_end,p_cavity_front_upper};
Line(l_cavity_front) = {p_cavity_front_upper,p_cavity_front_lower};
Line(l_cavity_bottom) = {p_cavity_front_lower,p_cavity_rear_lower};
Line(l_cavity_rear_1) = {p_cavity_rear_lower,p_injector_cavity_lower};
Line(l_cavity_rear_2) = {p_injector_cavity_upper,p_wall_surround_front_lower};
Line(l_cavity_rear_3) = {p_wall_surround_front_lower,p_wall_insert_front_upper};
Line(l_cavity_rear_4) = {p_wall_insert_front_upper,p_cavity_rear_upper};
Line(l_postcavity_flat_1) = {p_cavity_rear_upper,p_wall_insert_rear_upper};
Line(l_postcavity_flat_2) = {p_wall_insert_rear_upper,p_expansion_start};
Line(l_bottom_expansion) = {p_expansion_start,p_outlet_lower};

/*
Line(l_wall_insert_front) = {p_wall_insert_front_upper,p_wall_insert_front_lower};
Line(l_wall_insert_bottom) = {p_wall_insert_front_lower,p_wall_insert_rear_lower};
Line(l_wall_insert_rear) = {p_wall_insert_rear_lower,p_wall_insert_rear_upper};
Line(l_wall_surround_bottom) = {p_wall_surround_front_lower,p_wall_surround_rear_lower};
Line(l_wall_surround_rear) = {p_wall_surround_rear_lower,p_expansion_start};
*/

Line(l_injector_bottom) = {p_injector_cavity_lower,p_injector_entrance_lower};
Line(l_injector_inlet) = {p_injector_entrance_lower, p_injector_entrance_upper};
Line(l_injector_top) = {p_injector_entrance_upper, p_injector_cavity_upper};

//Outlet
l_outlet = l++;
Line(l_outlet) = {p_outlet_lower,p_outlet_upper};

//Top wall
l_postnozzle_top = l++;
Line(l_postnozzle_top) = {p_outlet_upper,p_nozzle_top_end};  // goes counter-clockwise

//Create lineloop of this geometry
// start on the bottom left and go around clockwise
Curve Loop(1) = {
-l_inlet,
l_nozzle_top,
-l_postnozzle_top,
-l_outlet,
-l_bottom_expansion,
-l_postcavity_flat_2,
-l_postcavity_flat_1,
-l_cavity_rear_4,
-l_cavity_rear_3,
-l_cavity_rear_2,
-l_injector_top,
-l_injector_inlet,
-l_injector_bottom,
-l_cavity_rear_1,
-l_cavity_bottom,
-l_cavity_front,
-l_isolator_to_cavity,
-l_nozzle_bottom
};

/*
//Create lineloops of wall regions
// start on the bottom left and go around clockwise
// Insert
Curve Loop(2) = {
-l_wall_insert_front,
l_cavity_rear_4,
l_postcavity_flat_1,
-l_wall_insert_rear,
-l_wall_insert_bottom
};
// Surround
Curve Loop(3) = {
l_cavity_rear_3,
l_wall_insert_front,
l_wall_insert_bottom,
l_wall_insert_rear,
l_postcavity_flat_2,
-l_wall_surround_rear,
-l_wall_surround_bottom
};
*/

Plane Surface(1) = {1};
/*Plane Surface(2) = {2};*/
/*Plane Surface(3) = {3};*/

/*
Physical Surface('fluid') = {-1};
Physical Surface('wall_insert') = {-2};
Physical Surface('wall_surround') = {3};

Physical Curve('inflow') = {-l_inlet};
Physical Curve('outflow') = {l_outlet};
Physical Curve('injection') = {l_injector_inlet};
Physical Curve('flow') = {-l_inlet, l_outlet, l_injector_inlet};
Physical Curve('isothermal_wall') = {
l_nozzle_top,
l_nozzle_bottom,
l_isolator_to_cavity,
l_cavity_front,
l_cavity_bottom,
l_cavity_rear_1,
l_cavity_rear_2,
l_injector_bottom,
l_injector_top,
l_bottom_expansion,
l_postnozzle_top
};
Physical Curve('fluid_wall_interface') = {
l_cavity_rear_3,
l_cavity_rear_4,
l_postcavity_flat_1,
l_postcavity_flat_2
};
Physical Curve('wall_farfield') = {
l_wall_surround_bottom,
l_wall_surround_rear
};
*/

// Create distance field from curves, excludes cavity
Field[1] = Distance;
Field[1].CurvesList = {
  l_nozzle_top,
  l_nozzle_bottom,
  l_isolator_to_cavity,
  l_postcavity_flat_2,
  l_bottom_expansion,
  l_postnozzle_top
};
Field[1].NumPointsPerCurve = 100000;

//Create threshold field that varrries element size near boundaries
Field[2] = Threshold;
Field[2].InField = 1;
Field[2].SizeMin = nozzlesize / boundratio;
Field[2].SizeMax = isosize;
Field[2].DistMin = 0.0002;
Field[2].DistMax = 0.005;
Field[2].StopAtDistMax = 1;

// Create distance field from curves, cavity only
Field[11] = Distance;
Field[11].CurvesList = {
  l_cavity_front,
  l_cavity_bottom,
  l_cavity_rear_1,
  l_cavity_rear_2
};
Field[11].NumPointsPerCurve = 100000;

//Create threshold field that varrries element size near boundaries
Field[12] = Threshold;
Field[12].InField = 11;
Field[12].SizeMin = cavitysize / boundratiocavity;
Field[12].SizeMax = cavitysize;
Field[12].DistMin = 0.0002;
Field[12].DistMax = 0.005;
Field[12].StopAtDistMax = 1;

// Create distance field from curves, inside wall only
Field[13] = Distance;
Field[13].CurvesList = {
  l_wall_insert_front,
  l_wall_insert_bottom,
  l_wall_insert_rear
};
Field[13].NumPointsPerCurve = 100000;

//Create threshold field that varrries element size near boundaries
Field[14] = Threshold;
Field[14].InField = 13;
Field[14].SizeMin = samplesize / boundratiosurround;
Field[14].SizeMax = samplesize;
Field[14].DistMin = 0.0002;
Field[14].DistMax = 0.005;
Field[14].StopAtDistMax = 1;

// Create distance field from curves, injector only
Field[15] = Distance;
Field[15].CurvesList = {l_injector_bottom, l_injector_top};
Field[15].NumPointsPerCurve = 10000;

//Create threshold field that varies element size near boundaries
Field[16] = Threshold;
Field[16].InField = 15;
Field[16].SizeMin = injectorsize / boundratioinjector;
Field[16].SizeMax = injectorsize;
Field[16].DistMin = 0.000001;
Field[16].DistMax = 0.0005;
Field[16].StopAtDistMax = 1;

// Create distance field from curves, sample/fluid interface
Field[17] = Distance;
Field[17].CurvesList = {
  l_postcavity_flat_1,
  l_cavity_rear_3,
  l_cavity_rear_4
};
Field[17].NumPointsPerCurve = 100000;

//Create threshold field that varies element size near boundaries
Field[18] = Threshold;
Field[18].InField = 17;
Field[18].SizeMin = cavitysize / boundratiosample;
Field[18].SizeMax = cavitysize;
Field[18].DistMin = 0.0002;
Field[18].DistMax = 0.005;
Field[18].StopAtDistMax = 1;

nozzle_start = 0.27;
nozzle_end = 0.30;
//  background mesh size in the isolator (downstream of the nozzle)
Field[3] = Box;
Field[3].XMin = nozzle_end;
Field[3].XMax = 1.0;
Field[3].YMin = -1.0;
Field[3].YMax = 1.0;
Field[3].VIn = isosize;
Field[3].VOut = bigsize;

// background mesh size upstream of the inlet
Field[4] = Box;
Field[4].XMin = 0.;
Field[4].XMax = nozzle_start;
Field[4].YMin = -1.0;
Field[4].YMax = 1.0;
Field[4].VIn = inletsize;
Field[4].VOut = bigsize;

// background mesh size in the nozzle throat
Field[5] = Box;
Field[5].XMin = nozzle_start;
Field[5].XMax = nozzle_end;
Field[5].YMin = -1.0;
Field[5].YMax = 1.0;
Field[5].Thickness = 0.10;    // interpolate from VIn to Vout over a distance around the box
Field[5].VIn = nozzlesize;
Field[5].VOut = bigsize;

// background mesh size in the cavity region
cavity_start = 0.65;
//cavity_end = 0.73;
cavity_end = 0.742;
Field[6] = Box;
Field[6].XMin = cavity_start;
Field[6].XMax = cavity_end;
Field[6].YMin = -1.0;
Field[6].YMax = -0.003;
Field[6].Thickness = 0.10;    // interpolate from VIn to Vout over a distance around the box
Field[6].VIn = cavitysize;
Field[6].VOut = bigsize;

// background mesh size for the injector
injector_start = 0.69;
injector_end = 0.75;
injector_bottom = -0.0215;
injector_top = -0.025;
Field[7] = Box;
Field[7].XMin = injector_start;
Field[7].XMax = injector_end;
Field[7].YMin = injector_bottom;
Field[7].YMax = injector_top;
Field[7].Thickness = 0.10;    // interpolate from VIn to Vout over a distance around the box
Field[7].VIn = injectorsize;
Field[7].VOut = bigsize;

// background mesh size in the sample region
Field[8] = Constant;
Field[8].SurfacesList = {2,3};
Field[8].VIn = samplesize;
Field[8].VOut = bigsize;

// keep the injector boundary spacing in the fluid mesh only
Field[20] = Restrict;
Field[20].SurfacesList = {1};
Field[20].InField = 16;

Field[21] = Restrict;
Field[21].SurfacesList = {1};
Field[21].InField = 7;

// take the minimum of all defined meshing fields
Field[100] = Min;
//Field[100].FieldsList = {2, 3, 4, 5, 6, 7, 12, 14, 16};
//Field[100].FieldsList = {2, 3, 4, 5, 6, 8, 12, 14, 16, 18};
Field[100].FieldsList = {2, 3, 4, 5, 6, 8, 12, 14, 18, 20, 21};
//Field[100].FieldsList = {2, 3, 4, 5, 6, 8};
//Field[100].FieldsList = {8};
Background Field = 100;

Mesh.MeshSizeExtendFromBoundary = 0;
Mesh.MeshSizeFromPoints = 0;
Mesh.MeshSizeFromCurvature = 0;

Extrude {0, 0, 0.01} {Surface {1}; Layers{1}; Recombine;}
/*Extrude {0, 0, 0.01} {Surface {2}; Layers{1}; Recombine;}*/
/*Extrude {0, 0, 0.01} {Surface {3}; Layers{1}; Recombine;}*/

Mesh 3;

Physical Surface("injector") = {14};
Physical Surface("inlet") = {3};
Physical Surface("outlet") = {6};
Physical Surface("front") = {1};
Physical Surface("back") = {20};
Physical Surface("wall") = {2,4,5,7,8,9,10,11,12,13,15,16,17,18,19};
Physical Volume("flow") = {1};
/*Physical Volume("porousMat") = {2};*/
/*Physical Volume("steel") = {3};*/

order = 1;
SetOrder order;
Mesh.MshFileVersion = 2.2;

Save "mesh.msh";
