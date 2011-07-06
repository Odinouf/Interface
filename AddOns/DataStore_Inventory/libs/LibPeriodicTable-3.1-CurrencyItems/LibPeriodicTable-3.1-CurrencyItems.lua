﻿-- (c) 2007 Nymbia.  see LGPLv2.1.txt for full details.
--DO NOT MAKE CHANGES TO THIS FILE BEFORE READING THE WIKI PAGE REGARDING CHANGING THESE FILES
if not LibStub("LibPeriodicTable-3.1", true) then error("PT3 must be loaded before data") end
LibStub("LibPeriodicTable-3.1"):AddData("CurrencyItems", gsub("$Rev: 346 $", "(%d+)", function(n) return n+90000 end), {
	["CurrencyItems.Apexis Crystal"]="32650:1,32652:1,32653:1,32654:1,32645:4,32647:4,32648:4,32651:4",
	["CurrencyItems.Apexis Shard"]="32784:2,32783:3,32596:10,32597:10,32599:10,32600:10,32828:10,32634:40,32635:40,32636:40,32637:40,32638:40,32639:40,32650:50,32652:50,32653:50,32654:50,33934:50,33935:50,32645:100,32647:100,32648:100,32651:100",
	["CurrencyItems.Arcane Rune"]="28903:2,28904:2,28907:2,28908:2,28909:8,28910:8,28911:8,28912:8",
	["CurrencyItems.Champion's Seal"]="46743:5,46744:5,46745:5,46746:5,46747:5,46748:5,46749:5,46750:5,46751:5,46752:5,45131:10,45152:10,45153:10,45154:10,45155:10,45156:10,45159:10,45160:10,45163:10,45181:10,45182:10,45183:10,45184:10,45206:10,45207:10,45209:10,45211:10,45213:10,45215:10,45216:10,45217:10,45218:10,45219:10,45220:10,45221:10,45223:10,45011:15,45013:15,45014:15,45015:15,45016:15,45017:15,45018:15,45019:15,45020:15,45021:15,46843:15,45074:25,45075:25,45076:25,45077:25,45078:25,45128:25,45129:25,45130:25,45203:25,45204:25,45205:25,45208:25,45210:25,45212:25,45214:25,45222:25,44965:40,44970:40,44971:40,44973:40,44974:40,44980:40,44982:40,44984:40,45002:40,45606:40,46820:40,46821:40,46817:50,46818:50,46874:50,42944:60,42945:60,42949:60,42950:60,42951:60,42952:60,42984:60,42985:60,48677:60,48683:60,48685:60,48687:60,48689:60,48691:60,42948:75,42991:75,42992:75,48716:75,42943:95,42946:95,42947:95,48718:95,45125:100,45586:100,45589:100,45590:100,45591:100,45592:100,45593:100,45595:100,45596:100,45597:100,46815:100,46816:100,47179:100,47180:100,45725:150,46813:150,46814:150,47541:150",
	["CurrencyItems.Coilfang Armaments"]="32903:1,32904:1",
	["CurrencyItems.Conquest Points"]="61388:700,61389:700,61390:700,61391:700,67464:700,67465:700,67466:700,67467:700,61360:950,67460:950,67475:950,67476:950,67477:950,67478:950,67479:950,60512:1250,60520:1250,60523:1250,60535:1250,60541:1250,60559:1250,60565:1250,60569:1250,60582:1250,60591:1250,60594:1250,60611:1250,60628:1250,60634:1250,60635:1250,60645:1250,60647:1250,60649:1250,60650:1250,60651:1250,60658:1250,60659:1250,60661:1250,60662:1250,60664:1250,60668:1250,60669:1250,60670:1250,60673:1250,60776:1250,60778:1250,60779:1250,60783:1250,60786:1250,60787:1250,60788:1250,60409:1650,60412:1650,60414:1650,60417:1650,60419:1650,60422:1650,60424:1650,60427:1650,60429:1650,60432:1650,60434:1650,60437:1650,60439:1650,60442:1650,60443:1650,60447:1650,60448:1650,60452:1650,60453:1650,60457:1650,60459:1650,60462:1650,60463:1650,60467:1650,60468:1650,60472:1650,60473:1650,60477:1650,60478:1650,60482:1650,60505:1650,60508:1650,60509:1650,60513:1650,60516:1650,60521:1650,60533:1650,60534:1650,60536:1650,60539:1650,60540:1650,60554:1650,60555:1650,60557:1650,60564:1650,60567:1650,60580:1650,60581:1650,60583:1650,60586:1650,60587:1650,60589:1650,60593:1650,60602:1650,60605:1650,60607:1650,60612:1650,60613:1650,60626:1650,60630:1650,60636:1650,60637:1650,60794:1650,60799:1650,60800:1650,60801:1650,60806:1650,60807:1650,61026:1650,61031:1650,61032:1650,61033:1650,61034:1650,61035:1650,61045:1650,61046:1650,61047:1650,60408:2200,60410:2200,60411:2200,60413:2200,60415:2200,60416:2200,60418:2200,60420:2200,60421:2200,60423:2200,60425:2200,60426:2200,60428:2200,60430:2200,60431:2200,60433:2200,60435:2200,60436:2200,60438:2200,60440:2200,60441:2200,60444:2200,60445:2200,60446:2200,60449:2200,60450:2200,60451:2200,60454:2200,60455:2200,60456:2200,60458:2200,60460:2200,60461:2200,60464:2200,60465:2200,60466:2200,60469:2200,60470:2200,60471:2200,60474:2200,60475:2200,60476:2200,60479:2200,60480:2200,60481:2200,60601:2200,60603:2200,60604:2200,61333:2450,67454:2450,67455:2450,67456:2450,67457:2450,67458:2450,67459:2450,67468:2450,67469:2450,67470:2450,67471:2450,67472:2450,67473:2450,67474:2450,61346:3400,67447:3400,67449:3400,67450:3400,67451:3400,67452:3400,67453:3400,67461:3400,67462:3400,67463:3400",
	["CurrencyItems.Frozen Orb"]="35622:1,35623:1,35624:1,35625:1,35627:1,36860:1,36908:1,45087:4,47556:6,54798:6",
	["CurrencyItems.Glowcap"]="25548:1,25550:1,30156:1,24539:2,27689:2,31775:10,25828:15,29149:20,22916:25,25827:25,38229:25,22906:30,34478:30,29150:45",
	["CurrencyItems.Halaa Battle Token"]="27637:20,27638:20,27639:20,27643:20,27644:20,27645:20,27646:20,27647:40,27648:40,27649:40,27650:40,27652:40,27653:40,27654:40,28915:70,27679:100,29228:100",
	["CurrencyItems.Halaa Research Token"]="27637:1,27638:1,27639:1,27643:1,27644:1,27645:1,27646:1,27647:2,27648:2,27649:2,27650:2,27652:2,27653:2,27654:2,32071:2,33783:4,27680:8,28915:15,29228:20",
	["CurrencyItems.Holy Dust"]="28878:2,28881:2,28882:2,28885:2,28886:8,28887:8,28888:8,28889:8",
	["CurrencyItems.Honor Points"]="68660:55,51478:260,64819:700,64820:700,64821:700,64822:700,51414:1040,51467:1040,51510:1040,51440:1140,51442:1140,51444:1140,51446:1140,51448:1140,51526:1140,51528:1140,51529:1140,64681:1250,64682:1250,64683:1250,64684:1250,64685:1250,64686:1250,64690:1250,64691:1250,64692:1250,64698:1250,64699:1250,64704:1250,64705:1250,64706:1250,64707:1250,64713:1250,64714:1250,64718:1250,64719:1250,64723:1250,64724:1250,64725:1250,64732:1250,64733:1250,64734:1250,64800:1250,64801:1250,64807:1250,64808:1250,64809:1250,64832:1250,64833:1250,64851:1250,64852:1250,64872:1250,64873:1250,51435:1650,51499:1650,64687:1650,64688:1650,64689:1650,64696:1650,64697:1650,64702:1650,64703:1650,64709:1650,64712:1650,64715:1650,64716:1650,64720:1650,64721:1650,64722:1650,64727:1650,64731:1650,64736:1650,64739:1650,64740:1650,64741:1650,64742:1650,64745:1650,64747:1650,64750:1650,64751:1650,64753:1650,64754:1650,64756:1650,64757:1650,64761:1650,64762:1650,64763:1650,64764:1650,64768:1650,64769:1650,64772:1650,64777:1650,64780:1650,64781:1650,64782:1650,64785:1650,64788:1650,64789:1650,64790:1650,64791:1650,64792:1650,64793:1650,64794:1650,64795:1650,64798:1650,64803:1650,64806:1650,64812:1650,64815:1650,64828:1650,64831:1650,64834:1650,64835:1650,64836:1650,64837:1650,64838:1650,64841:1650,64844:1650,64847:1650,64853:1650,64855:1650,64862:1650,64863:1650,64864:1650,64865:1650,64866:1650,64867:1650,64868:1650,64869:1650,64870:1650,64874:1650,64878:1650,64708:2200,64710:2200,64711:2200,64728:2200,64729:2200,64730:2200,64735:2200,64737:2200,64738:2200,64746:2200,64748:2200,64749:2200,64765:2200,64766:2200,64767:2200,64770:2200,64771:2200,64773:2200,64776:2200,64778:2200,64779:2200,64784:2200,64786:2200,64787:2200,64796:2200,64797:2200,64799:2200,64802:2200,64804:2200,64805:2200,64811:2200,64813:2200,64814:2200,64827:2200,64829:2200,64830:2200,64839:2200,64840:2200,64842:2200,64843:2200,64845:2200,64846:2200,64854:2200,64856:2200,64857:2200,64875:2200,64876:2200,64877:2200,51516:2745,51518:2745,51520:2745,51522:2745,51524:2745,51398:3235,51399:3235,51454:3235,51389:3825,51391:3825,51393:3825,51395:3825,51401:3825,51403:3825,51405:3825,51412:3825,51432:3825,51450:3825,51457:3825,51481:3825",
	["CurrencyItems.Justice Points"]="50454:347,50455:347,50456:347,50457:347,50458:347,50459:347,50460:347,50461:347,50462:347,50463:347,50464:347,50474:347,50466:579,50467:579,50468:579,50469:579,50470:579,40810:695,40811:695,40812:695,40870:695,40871:695,40928:695,41002:695,41039:695,41144:695,41218:695,41276:695,41294:695,41684:695,41768:695,41941:695,41966:695,42018:695,50079:695,50095:695,50098:695,50113:695,50114:695,50117:695,50275:695,50279:695,50355:695,50356:695,50357:695,50358:695,50391:695,50822:695,50824:695,50834:695,50836:695,50845:695,50846:695,50856:695,50860:695,50863:695,50976:695,50977:695,50978:695,50979:695,50980:695,50981:695,50982:695,50983:695,50984:695,50987:695,50989:695,50991:695,50992:695,50993:695,50994:695,50995:695,50996:695,50997:695,57923:950,57924:950,57925:950,57926:950,57927:950,57928:950,57929:950,40851:1100,40852:1100,40910:1100,40940:1100,41014:1100,41028:1100,41082:1100,41088:1100,41158:1100,41206:1100,41305:1100,41317:1100,41322:1100,41656:1100,41668:1100,41673:1100,41855:1100,41865:1100,41916:1100,41928:1100,41954:1100,41994:1100,41999:1100,42006:1100,50078:1100,50080:1100,50090:1100,50094:1100,50096:1100,50097:1100,50115:1100,50116:1100,50276:1100,50277:1100,50278:1100,50392:1100,50765:1100,50820:1100,50821:1100,50823:1100,50825:1100,50832:1100,50833:1100,50835:1100,50844:1100,50847:1100,50848:1100,50857:1100,50861:1100,50862:1100,50869:1100,50965:1100,50968:1100,50969:1100,50970:1100,50971:1100,50972:1100,50973:1100,50974:1100,50975:1100,57930:1250,57931:1250,57932:1250,57933:1250,57934:1250,57913:1650,57914:1650,57915:1650,57916:1650,57917:1650,57918:1650,57919:1650,57921:1650,57922:1650,58099:1650,58100:1650,58104:1650,58105:1650,58109:1650,58110:1650,58124:1650,58125:1650,58129:1650,58130:1650,58134:1650,58138:1650,58151:1650,58152:1650,58157:1650,58158:1650,58162:1650,58163:1650,58096:2200,58097:2200,58098:2200,58101:2200,58102:2200,58103:2200,58106:2200,58107:2200,58108:2200,58121:2200,58122:2200,58123:2200,58126:2200,58127:2200,58128:2200,58131:2200,58132:2200,58133:2200,58139:2200,58140:2200,58150:2200,58153:2200,58154:2200,58155:2200,58159:2200,58160:2200,58161:2200",
	["CurrencyItems.Mark of Honor Hold"]="24520:5,27809:10,27812:10,28361:10,63696:10,27833:15,27834:15,27929:15,27931:15,27942:15,27983:15,27984:15,27990:15,27921:30,27922:30,27927:30",
	["CurrencyItems.Mark of the Illidari"]="32898:1,32899:1,32900:1,32901:1,35716:1,35717:1",
	["CurrencyItems.Mark of Thrallmar"]="24522:5,27777:10,27786:10,28360:10,63697:10,27830:15,27832:15,27928:15,27930:15,27939:15,27947:15,27949:15,27989:15,27920:30,27924:30,27926:30",
	["CurrencyItems.Spirit Shard"]="32947:2,32948:2,28556:8,28557:8,28559:18,28560:18,28561:18,28574:18,28575:18,28576:18,28577:18,28758:18,28759:18,28760:18,28761:18,28553:50,28555:50",
	["CurrencyItems.Sunmote"]="34381:1,34382:1,34383:1,34384:1,34385:1,34386:1,34388:1,34389:1,34390:1,34391:1,34392:1,34393:1,34394:1,34395:1,34396:1,34397:1,34398:1,34399:1,34400:1,34401:1,34402:1,34403:1,34404:1,34405:1,34406:1,34407:1,34408:1,34409:1",
	["CurrencyItems.Tol Barad Commendation"]="63144:2,63145:2,64993:2,64994:2,63391:5,64995:5,63517:10,63518:10,63141:40,63378:40,63379:40,64997:40,65175:40,65176:40,68768:40,68769:40,68770:40,63355:50,63376:50,63377:50,64996:50,68772:80,68773:80,68774:80,62454:85,62455:85,62456:85,62457:85,62458:85,62459:85,62460:85,62473:85,62474:85,62475:85,62476:85,62477:85,62478:85,62479:85,68739:85,68740:85,62463:125,62464:125,62465:125,62466:125,62467:125,62468:125,62469:125,62470:125,62471:125,62472:125,64998:165,64999:165,63039:200,65356:200",
	["CurrencyItems.Valor Points"]="64671:700,64672:700,64673:700,64674:700,64676:700,58185:1250,58187:1250,58188:1250,58189:1250,58190:1250,58191:1250,58192:1250,58193:1250,58194:1250,68812:1250,58180:1650,58181:1650,58182:1650,58183:1650,58184:1650,58195:1650,58197:1650,58198:1650,58199:1650,58481:1650,58482:1650,58484:1650,58485:1650,58486:1650,60247:1650,60248:1650,60257:1650,60275:1650,60280:1650,60285:1650,60290:1650,60298:1650,60307:1650,60312:1650,60314:1650,60319:1650,60326:1650,60332:1650,60340:1650,60345:1650,60350:1650,60355:1650,60363:1650,60244:2200,60245:2200,60250:2200,60251:2200,60254:2200,60255:2200,60259:2200,60261:2200,60276:2200,60278:2200,60281:2200,60283:2200,60287:2200,60288:2200,60300:2200,60301:2200,60304:2200,60305:2200,60309:2200,60310:2200,60313:2200,60316:2200,60318:2200,60321:2200,60323:2200,60324:2200,60329:2200,60330:2200,60339:2200,60342:2200,60344:2200,60347:2200,60349:2200,60352:2200,60354:2200,60357:2200,60360:2200,60361:2200",
	["CurrencyItems.Winterfin Clam"]="38350:1,38351:2,37449:5,37464:5,36783:30,37462:30,37463:30,37461:50,36784:100",

-- PROFESSIONS
--   Blacksmithing
	["CurrencyItems.Elementium Bar"]="66103:20,66105:20,66107:20,66109:20,66117:20,66118:20,66119:20,66125:20,66126:20,66127:20",
	["CurrencyItems.Hardened Elementium Bar"]="66104:2,66106:2,66108:2,66110:2,66111:2,66112:2,66113:2,66114:2,66115:2,66116:2,66120:2,66121:2,66128:2,66129:2,67603:2",
	["CurrencyItems.Pyrium Bar"]="66100:5,66101:5,66122:5,66123:5,66124:5,66130:5,66131:5,66132:5,67606:5",
--   Cooking
	["CurrencyItems.Dalaran Cooking Award"]="43007:1,43018:3,43019:3,43020:3,43021:3,43022:3,43023:3,43024:3,43025:3,43026:3,43027:3,43028:3,43029:3,43030:3,43031:3,43032:3,43033:3,43034:3,43035:3,43036:3,43037:3,43505:3,43506:3,44954:3,43017:5,46349:100",
	["CurrencyItems.Chef's Award"]="68689:1,65513:2,65406:3,65407:3,65408:3,65409:3,65410:3,65411:3,65412:3,65413:3,65414:3,65415:3,65416:3,65417:3,65418:3,65419:3,65420:3,65421:3,65422:3,65423:3,65424:3,65425:3,65426:3,65427:3,65428:3,65429:3,65430:3,65431:3,68688:3,65432:5,65433:5",
--   Enchanting
	["CurrencyItems.Dream Shard"]="37340:4,37347:4,37349:4,44471:4,44472:4,44484:4,44485:4,44488:4,44489:4,44490:4,44491:4,44498:4,37339:10,37344:10,44473:10,44483:10,44486:10,44487:10,44492:10,44494:10,44495:10,44496:10,45059:10",
	["CurrencyItems.Abyss Crystal"]="44944:5",
	["CurrencyItems.Hypnotic Dust"]="67308:20,67312:20",
	["CurrencyItems.Heavenly Shard"]="65359:1,52737:5,52738:5,52739:5,52740:5,64411:5,64412:5,64413:5,64414:5,64415:5",
	["CurrencyItems.Maelstrom Crystal"]="52733:5,52735:5,52736:5",
--   Jewelcrafting
	["CurrencyItems.Dalaran Jewelcrafter's Token"]="42225:1,42298:2,42301:2,42302:2,42305:2,42306:2,42307:2,42308:2,42309:2,42310:2,42311:2,42312:2,42313:2,42314:2,41576:3,41577:3,41578:3,41579:3,41580:3,41581:3,41582:3,41686:3,41687:3,41688:3,41690:3,41692:3,41693:3,41696:3,41697:3,41698:3,41702:3,41719:3,41747:3,42138:3,43317:4,43318:4,43319:4,43320:4,43485:4,43497:4,46897:4,46898:4,46899:4,46901:4,46902:4,46904:4,46905:4,46909:4,46911:4,46912:4,46913:4,46915:4,46916:4,46917:4,46918:4,46920:4,46922:4,46923:4,46924:4,46925:4,46926:4,46928:4,46929:4,46932:4,46933:4,46935:4,46937:4,46938:4,46941:4,46942:4,46943:4,46948:4,46949:4,46950:4,46951:4,46952:4,46953:4,46956:4,47007:4,47010:4,47015:4,47017:4,47018:4,47019:4,47020:4,47021:4,47022:4,49112:4,41704:5,41705:5,41706:5,41707:5,41708:5,41709:5,41710:5,41711:5,42648:6,42649:6,42650:6,42651:6,42652:6,42653:6,43597:6",
	["CurrencyItems.Illustrious Jewelcrafter's Token"]="52196:1,52381:2,52447:2,52448:2,52449:2,52450:2,52451:2,52452:2,52453:2,52454:2,52455:2,52456:2,52457:2,52458:2,52459:2,52362:3,52380:3,52384:3,52387:3,52389:3,52390:3,52391:3,52392:3,52393:3,52394:3,52395:3,52396:3,52397:3,52398:3,52399:3,52400:3,52401:3,52402:3,52403:3,52404:3,52405:3,52406:3,52407:3,52408:3,52409:3,52410:3,52411:3,52412:3,52413:3,52414:3,52415:3,52416:3,52417:3,52418:3,52419:3,52420:3,52421:3,52422:3,52423:3,52424:3,52425:3,52426:3,52427:3,52428:3,52429:3,52430:3,52431:3,52432:3,68359:3,68360:3,68361:3,68742:3,52433:4,52434:4,52435:4,52436:4,52437:4,52438:4,52439:4,52440:4,52441:4,52442:4,52443:4,52444:4,52445:4,52460:5,52461:5,52462:5,52463:5,52464:5,52465:5,52466:5,52467:5",
--   Leatherworking
	["CurrencyItems.Heavy Borean Leather"]="44513:3,44514:3,44515:3,44516:3,44517:3,44518:3,44519:3,44520:3,44521:3,44522:3,44523:3,44524:3,44525:3,44526:3,44527:3,44528:3,44530:3,44531:3,44532:3,44533:3,44534:3,44535:3,44536:3,44537:3,44538:3,44539:3,44540:3,44541:3,44542:3,44543:3,44544:3,44545:3,44584:3,44585:3,44586:3,44587:3,44588:3,44589:3,44128:10",
	["CurrencyItems.Arctic Fur"]="44546:2,44547:2,44548:2,44549:2,44550:2,44551:2,44552:2,44553:2,44932:2,44933:2",
	["CurrencyItems.Heavy Savage Leather"]="52980:10,67042:10,67044:10,67046:10,67048:10,67049:10,67053:10,67054:10,67055:10,67056:10,67058:10,67060:10,67062:10,67063:10,67064:10,67065:10,67066:10,67068:10,67070:10,67072:10,67073:10,67074:10,67075:10,67076:10,67077:10,67078:10,67079:10,67080:10,67081:10,67082:10,67083:10,67084:10,67085:10,67086:10,67087:10,67089:10,67090:10,67091:10,67092:10,67093:10,67094:10,67095:10,67096:10,67100:10,68193:10",
--   Tailoring
	["CurrencyItems.Bolt of Embersilk Cloth"]="54593:8,54594:8,54595:8,54596:8,54597:8,54598:8,54599:8,54600:8,68199:8",
	["CurrencyItems.Dreamcloth"]="54601:1,54602:1,54603:1,54604:1,54605:1",

-- SEASONAL
	["CurrencyItems.Brewfest Prize Token"]="37750:2,39476:5,39477:5,37816:20,33864:50,33967:50,33968:50,33969:50,33047:100,33868:100,33927:100,33966:100,34008:100,46707:100,33862:200,33863:200,37736:200,37737:200",
	["CurrencyItems.Burning Blossom"]="23246:2,34684:2,23211:5,23215:5,23326:5,23327:5,23435:5,34599:5,23324:100,34685:100,34683:200,23083:350,34686:350",
	["CurrencyItems.Coin of Ancestry"]="21537:1,21157:5,21538:5,21539:5,21541:5,21543:5,21544:5,21640:5,21740:5,21741:5,21742:5,21743:5,44916:5,44917:5,44918:5,44919:5",
	["CurrencyItems.Noblegarden Chocolate"]="44818:5,44792:10,6833:25,6835:25,19028:50,44800:50,44803:50,45073:50,44793:100,44794:100",
})
