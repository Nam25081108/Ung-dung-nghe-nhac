import 'package:t4/models/song.dart';

// Lớp mới để lưu trữ thông tin bài hát yêu thích của người dùng
class UserFavorite {
  final String userId;
  final int songId;

  UserFavorite({
    required this.userId,
    required this.songId,
  });
}

// Danh sách bài hát yêu thích của người dùng
List<UserFavorite> userFavorites = [];

// Kiểm tra một bài hát có được yêu thích bởi người dùng hay không
bool isSongFavoriteByUser(int songId, String userId) {
  return userFavorites.any(
      (favorite) => favorite.songId == songId && favorite.userId == userId);
}

// Thêm hoặc xóa bài hát khỏi danh sách yêu thích
void toggleFavorite(int songId, String userId) {
  final existingIndex = userFavorites.indexWhere(
      (favorite) => favorite.songId == songId && favorite.userId == userId);

  if (existingIndex >= 0) {
    // Xóa khỏi danh sách yêu thích
    userFavorites.removeAt(existingIndex);
  } else {
    // Thêm vào danh sách yêu thích
    userFavorites.add(UserFavorite(userId: userId, songId: songId));
  }
}

// Lấy danh sách bài hát yêu thích của người dùng
List<Song> getFavoriteSongs(String userId) {
  List<int> favoriteSongIds = userFavorites
      .where((favorite) => favorite.userId == userId)
      .map((favorite) => favorite.songId)
      .toList();

  return songList.where((song) => favoriteSongIds.contains(song.id)).toList();
}

final List<Song> songList = [
  Song(
    id: 1,
    title: 'Ái Nộ',
    artist: 'Masew, Khôi Vũ',
    coverImage: 'assets/images/ai_no.png',
    assetPath: 'assets/audio/ai_no.mp3',
    lyrics: '''Em đi qua con phố
Đèn xanh đỏ vẫn sáng
Anh như đang ngồi đó
Nhưng tim thì vắng lặng...''',
  ),
  Song(
    id: 2,
    title: 'Chìm Sâu',
    artist: 'MCK',
    coverImage: 'assets/images/chim_sau.png',
    assetPath: 'assets/audio/chim_sau.mp3',
    lyrics:
        '\'\'Em đi qua con phố\nĐèn xanh đỏ vẫn sáng\nAnh như đang ngồi đó\nNhưng tim thì vắng lặng...\'\'',
  ),
  Song(
    id: 3,
    title: 'Tại Vì Sao',
    artist: 'MCK',
    coverImage: 'assets/images/tai_vi_sao.png',
    assetPath: 'assets/audio/tai_vi_sao.mp3',
    lyrics:
        '\'\'Em đi qua con phố\nĐèn xanh đỏ vẫn sáng\nAnh như đang ngồi đó\nNhưng tim thì vắng lặng...\'\'',
  ),
  Song(
    id: 4,
    title: 'Chúng Ta Của Hiện Tại',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/chung_ta_cua_hien_tai.png',
    assetPath: 'assets/audio/chung_ta_cua_hien_tai.mp3',
    lyrics:
        '\'\'Em đi qua con phố\nĐèn xanh đỏ vẫn sáng\nAnh như đang ngồi đó\nNhưng tim thì vắng lặng...\'\'',
  ),
  Song(
    id: 5,
    title: 'Đơn Giản',
    artist: 'Low G',
    coverImage: 'assets/images/don_gian.png',
    assetPath: 'assets/audio/don_gian.mp3',
    lyrics: '''Em đi qua con phố
Đèn xanh đỏ vẫn sáng
Anh như đang ngồi đó
Nhưng tim thì vắng lặng...''',
  ),
  Song(
    id: 6,
    title: 'Flower',
    artist: 'Jisso',
    coverImage: 'assets/images/flower.png',
    assetPath: 'assets/audio/flower.mp3',
    lyrics: '''Em đi qua con phố
Đèn xanh đỏ vẫn sáng
Anh như đang ngồi đó
Nhưng tim thì vắng lặng...''',
  ),
  Song(
    id: 7,
    title: 'See Tình',
    artist: 'Hoàng Thùy Linh',
    coverImage: 'assets/images/see_tinh.png',
    assetPath: 'assets/audio/see_tinh.mp3',
    lyrics:
        '\'\'Em đi qua con phố\nĐèn xanh đỏ vẫn sáng\nAnh như đang ngồi đó\nNhưng tim thì vắng lặng...\'\'',
  ),
  Song(
    id: 8,
    title: 'Exit Sign',
    artist: 'HIEUTHUHAI',
    coverImage: 'assets/images/exit_sign.png',
    assetPath: 'assets/audio/exit_sign.mp3',
    lyrics:
        '''Anh không nhớ nổi lần cuối cùng anh nhìn vào mắt em đó là từ bao giờ
Em từng trách anh chỉ ôm ước mơ còn không sợ mất em thì làm sao chờ
Lúc đó anh có xin lỗi hay không thì kết quả nó cũng như nhau mà
Cuối cùng thì hai ta đều ích kỷ nông nổi tự trọng cao mà
Ta từng bắt gặp nhau ở khắp Sài Gòn chắc là lúc còn yêu dù muốn tránh cũng khó
Không thể tin là mình chưa từng gặp lại sau khi mà anh bước qua cánh cửa đó
Tình yêu mình từng là ánh lửa đỏ từng là chim sẻ cố đập cánh giữa gió
Cố gắng sống hai cuộc đời chắc là thằng nhóc này muốn làm thần thánh nữa đó
Sao giờ em xuất hiện tại đây vầy
Cuối hàng khán giả và cánh tay vẫy
Em từng cùng anh đứng ở hậu trường và cùng anh về nhà sau khi mà bay nhảy
Cũng từng nói em không có gạt anh em thích nhạc anh and you know the vision
Anh từng hứa là mình không nhạt đâu sẽ không lạc nhau cùng bên nhau vào khi cần
Ngay lúc đó anh chỉ muốn lao xuống anh thật sự tò mò em dạo này khoẻ không
Nhưng mà sao hôm nay đi khuya vậy
Ba mẹ biết là ba mẹ sẽ trông
Anh từng mong em hạnh phúc tới khi em nở nụ cười anh như bị đâm mười nhát
Khi anh đứng trên sân khấu một mình coi em đứng cạnh cùng với một người khác
Em hiểu rằng chúng ta không ai là sai (hah)
Chỉ là em không muốn em mãi sẽ là lựa chọn thứ hai
Mãi sau những điều anh cho là lý do để anh tồn tại
Vậy đâu còn lý do để em ở lại
Đây sẽ là lý do em sẽ thôi đắn đo cứ ôm mộng hoài
So thanks for showing me the exit sign
Chưa nói tới đúng sai nhưng chuyến xe dừng lại là do chân anh đặt trên phanh
Anh đã không ngần ngại chia con đường làm hai vì anh nghĩ là anh quên nhanh
Gặp một cô gái mới coi là cả thế giới
Viết tên cả hai lên tranh không dễ nhiều đêm trắng để chờ lên nắng giờ thì kí ức gọi tên anh nên là cứ rót đi
Bàn vẫn ướt mặc dù có lót ly
Ước gì có thể paste nổi đau này qua chỗ khác nhưng không nó nhân lên nó chỉ copy
Thật khó để nhìn xung quanh khi chỉ trông ngóng vì sao như Xi ôn cốp xki
Để bây giờ em đi mất liên kết còn lại tồn tại giữa anh và em là chung một tài khoản Shopee
Gom hết tất cả về em xong rồi thiêu nhanh
Giọng em vang lên trước khi môi em mở găm thẳng vào anh như là siêu thanh
Không cần phải là người giỏi toán đủ biết đây không phải đổi ngang
Em chỉ mất đi một thằng thất bại anh mất đi một người yêu anh
Tám ngàn năm trăm mười lăm lần nói anh yêu em ở trong mess nếu mà em search
Cũng tới lúc mình phải quên đi thôi dù từng có với nhau là rất nhiều cam kết
Tiếc nhất không phải chia tay mà là không yêu em nhiều hơn trước lúc tình yêu chết
Có lẽ phải ghi tên em vào credit vì bài nhạc nào anh cũng viết về em hết
Em hiểu rằng chúng ta không ai là sai (hah)
Chỉ là em không muốn em mãi sẽ là lựa chọn thứ hai
Mãi sau những điều anh cho là lý do để anh tồn tại
Vậy đâu còn lý do để em ở lại (đâu cần một lý do ở lại)
Đây sẽ là lý do em sẽ thôi đắn đo cứ ôm mộng hoài
So thanks for showing me the exit sign
Hah hãy gìn giữ nhau trong những kỉ niệm
I thank you for finally showing me the exit sign hmm
Thanks for showing me the exit sign...''',
  ),
  Song(
    id: 9,
    title: 'See You Again',
    artist: 'Wiz Khalifa',
    coverImage: 'assets/images/see_you_again.png',
    assetPath: 'assets/audio/see_you_again.mp3',
    lyrics: '''Em đi qua con phố
Đèn xanh đỏ vẫn sáng
Anh như đang ngồi đó
Nhưng tim thì vắng lặng...''',
  ),
  Song(
    id: 10,
    title: 'Dữ Liệu Quý',
    artist: 'Dương Domic',
    coverImage: 'assets/images/du_lieu_quy.png',
    assetPath: 'assets/audio/du_lieu_quy.mp3',
    lyrics: '''Em đi qua con phố
Đèn xanh đỏ vẫn sáng
Anh như đang ngồi đó
Nhưng tim thì vắng lặng...''',
  ),
  // Bạn có thể thêm nhiều bài hát khác tại đây
  Song(
    id: 11,
    title: 'Dont côi',
    artist: 'Ronboogz',
    coverImage: 'assets/images/don_t_c__i.jpg',
    assetPath: 'assets/audio/don_t_c__i.mp3',
    lyrics: 'Dont Côi',
  ),
  Song(
    id: 13,
    title: 'Chỉ một đêm nữa thôi',
    artist: 'MCK',
    coverImage: 'assets/images/ch____m___t_____m_n___a_th__i.jpg',
    assetPath: 'assets/audio/ch____m___t_____m_n___a_th__i.mp3',
    lyrics: 'ghjghhasda\nsád\n\nád\nád\n\nád',
    album: '1%',
  ),  Song(
    id: 14,
    title: 'Lan man',
    artist: 'Ronboogz',
    coverImage: 'assets/images/lan_man.jpg',
    assetPath: 'assets/audio/lan_man.mp3',
    lyrics: '\nEm thức giấc khi đêm muộn,\nQuăng chiếc tất lên trên giường\nNgân nga khúc nhạc em chọn \nChỉ để thiên đường càng thêm buồn\nEm bước chân ra đường \nBỏ lại suy nghĩ trên ga giường\nVà đi đến một nơi \nMà em biết chắc anh đang ở đây\n\nVà anh vốn chỉ là người cũng hay thức \nCố gắng cho lòng mình ngừng day dứt\nDùng cây bút từng giây phút\nAnh chỉ đại trà như người dùng Facebook\nAnh chỉ muốn ngủ ngon giữa đêm \nNhưng lại nhớ màu son của em \n\nVì nắng sẽ chẳng bên cạnh khi ta \nlại để nước mắt rơi\nEm có thấy gió đêm lạnh những lúc niềm đau đó cất lời?\nVì ta luôn luôn đi trễ chỉ trong vài giây để lỡ vòng tay cả đời\nVà anh chẳng muốn chỉ sống như vậy mà thôi \nĐể có em mỗi đêm về khi trên trời cao lắm bóng mây \nNếu mưa cứ rơi hoài thì căn phòng kia vẫn nóng nảy\nTa luôn có thì giờ dù em không muốn mình chờ đợi thêm\nAnh chỉ muốn được sống như vậy mà thôi \n\nĐừng đẩy nhau như nam châm chỉ vì ta trước giờ luôn luôn cùng cực \nAnh chỉ viết ra thang âm khi nhiều thứ vẫn kìm nén trong lòng ngực mình \nBao nhiêu suy nghĩ như cực hình, khiến em bực mình\nVậy thì thứ mà em cần đến là một cuộc tình\n\nAnh chỉ muốn dạo phố mỗi tối, khi niềm đau lên ngôi \nNên em đừng cố nói dối với từng câu trên môi \nNhững ai luôn tệ khi khiến em tuôn lệ \nChúng ta quên cách để buông nhẹ\nVậy thì ta sẽ biết điều đó trên đoạn đường về \n\nVì nắng sẽ chẳng bên cạnh khi ta \nlại để nước mắt rơi\nEm có thấy gió đêm lạnh những lúc niềm đau đó cất lời?\nVì ta luôn luôn đi trễ chỉ trong vài giây để lỡ vòng tay cả đời\nVà anh chẳng muốn chỉ sống như vậy mà thôi \nĐể có em mỗi đêm về khi trên trời cao lắm bóng mây \nNếu mưa cứ rơi hoài thì căn phòng kia vẫn nóng nảy\nTa luôn có thì giờ dù em không muốn mình chờ đợi thêm\nAnh chỉ muốn được sống như vậy mà thôi \n\nChỉ muốn cùng em đón ngọn gió đêm về\nEm như mặt trăng khi anh ở đâu thì anh cũng có em kề\nChỉ muốn cùng em say sưa vài lon\nUống cho đêm dài hơn\nMuốn say thêm vài cơn cùng em \n\nVì nắng sẽ chẳng bên cạnh khi em \nlại để nước mắt rơi\nEm có thấy gió đêm lạnh những lúc niềm đau đó cất lời?\nVì ta luôn luôn đi trễ chỉ trong vài giây để lỡ vòng tay cả đời\nVà anh chẳng muốn chỉ sống như vậy mà thôi \nĐể có em mỗi đêm về khi trên trời cao lắm bóng mây \nNếu mưa cứ rơi hoài thì căn phòng kia vẫn nóng nảy\nTa luôn có thì giờ dù em không muốn mình chờ đợi thêm\nAnh chỉ muốn được sống như vậy mà thôi',
  ),
Song(
    id: 16,
    title: 'Vì chúng ta là con người',
    artist: 'Ronboogz',
    coverImage: 'assets/images/v___ch__ng_ta_l___con_ng_____i.jpg',
    assetPath: 'assets/audio/v___ch__ng_ta_l___con_ng_____i.mp3',
    lyrics: 'Vì chúng ta là con người',
  ),
  Song(
    id: 17,
    title: 'Khi mà',
    artist: 'Ronboogz',
    coverImage: 'assets/images/khi_m__.jpg',
    assetPath: 'assets/audio/khi_m__.mp3',
    lyrics:
        'Năm anh lên 6, thích xem hoạt hình Nhưng anh không thích nước mắt rớt trên mặt mình \nKhi ba nói anh càng lớn thì càng lười \nCon mà học dốt mai sau lấy gì làm người? \nNăm anh 16, thích viết nhạc tình\n Mẹ anh hay nói đừng để nó lừa gạt mình Những sự hào nhoáng con thấy trên truyền hình\n Luôn kèm những thứ đang mong muốn làm phiền mình \nNăm anh 26 vẫn cố kiếm kế sinh nhai. Yêu đương hơi khó khi chẳng biết sẽ tin ai \nMẹ anh hay nói phải kiếm đứa làm bà vui Dù con mới chính là người cùng họ già cỗi \nAnh bước lân la, ngay trước sân ga. \nKhi em ngồi xuống hàng ghế đá trước chân ta \nTa chẳng nhìn nhau. Em hỏi vài câu\nKhi nào anh mới sống đúng đây?\n Khi nào anh mới hết đắng cay? \nKhi nào anh mới vui? \nAnh chẳng biết nói gì, và đó là khi \nKhi mình không muốn khóc trước em \nKhi bàn chân lặng lẽ bước lên \nĐể em chẳng thấy mình buồn \nĐể cho mọi thứ bình thường \nNăm anh 26, bạn bè anh có nhà ba gian Lôi chuyện anh không có nhà ra than \nVà anh cố để mà kiếm được việc làm \nVì sự thanh công luôn được tính bằng tiền bạc \nKhi anh 36 đứa con của mình đang lớn dần \nAnh ho ra máu với công việc thêm cuối tuần \nNhưng ai thấu vì điều đó chỉ làm mình thêm muối mặt \nVà đời vốn không trả công cho những ai đang cúi mặt\nLúc 46 con anh lớn khôn, cần có số vốn làm điều lớn hơn, và \nNó muốn sống không muốn giống anh Anh bước lân la, ngay trước sân ga.\n Khi em ngồi xuống hàng ghế đá trước chân ta \nTa chẳng nhìn nhau Em hỏi vài câu \nKhi nào anh mới sống đúng đây? \nKhi nào anh mới hết đắng cay? \nKhi nào anh mới vui? \nAnh chẳng biết nói gì, và đó là khi \nKhi mình không muốn khóc trước em \nKhi bàn chân lặng lẽ bước lên \nĐể em chẳng thấy mình buồn \nĐể cho mọi thứ bình thường\nLúc 66 anh chẳng thể đến được nơi nào Những ước muốn khi ấu thơ tiếp tục bơi vào \nChỉ có sóng gió phía trước đã ngừng khơi mào Nhưng mà anh… \nKhi nào anh mới sống đúng đây? \nKhi nào anh mới hết đắng cay? \nKhi nào anh mới vui? \nAnh chẳng biết nói gì, và đó là khi \nKhi mình không muốn khóc trước em \nKhi bàn chân lặng lẽ bước lên \nĐể em chẳng thấy mình buồn \nĐể cho mọi thứ bình thường',
  ),
  Song(
    id: 18,
    title: 'Tháp drill tự do',
    artist: 'MCK',
    coverImage: 'assets/images/th__p_drill_t____do.jpg',
    assetPath: 'assets/audio/th__p_drill_t____do.mp3',
    lyrics:
        'Người đi anh còn chẳng muốn viết thêm tình ca\n\nCảm xúc đã quá ứ động anh chẳng thể nói ra\n\nChẳng còn nhòe đi mắt ướt\n\nChẳng buồn như lúc trước\n\nThời gian trôi qua thấm thoát khiến lá thay màu sắc\n\nBaby buông tay anh rời xa giờ anh thấy tự do\n\nHéo úa bao nhiêu thời gian ngước mắt lên nhìn cung đàn\n\nNhư cơn mưa mùa đông chợt ghé qua\n\nCứ coi anh gột sạch rồi trôi xa\n\nCon tim bình yên vấn vương nơi em nhiều\n\nGiờ anh là cánh chim bay chơi vơi tìm nơi chốn\n\nCũng chẳng thể vội vàng xóa nhòa đi\n\nTrước khi tiệc tàn hạ màn anh sẽ đi\n\nCon tim không nghe lời lý trí\n\nBiết trước đến lúc lụi tàn\n\nMắt đầm mi cuồng si\n\nEm đi bước qua cuộc đời thôi\n\nLời em nói còn lại nơi này..',
  ),
  Song(
    id: 19,
    title: 'Anh vẫn đợi',
    artist: 'Shiki',
    coverImage: 'assets/images/anh_v___n______i.png',
    assetPath: 'assets/audio/anh_v___n______i.mp3',
    lyrics:
        'Dù nhiều cơn đau như thiêu chết\nBut anh vẫn không thể rời xa girl, anh không thể\nDù cho dao đâm hàng triệu nhát\nDẫu có bao vết thương anh vẫn đợi\n\nEm là người trong mỗi câu chuyện\nEm là chủ đề viết rất riêng\nVì em là một điều đặt biệt\nMà cả thế giới đang tìm nên là\nDẫu có bao vết thương anh vẫn đợi\n\nMy darling oh\nMy darling oh\nDù nhiều lần lặng im đến đau thắt trái tim anh\nDẫu có bao vết thương anh vẫn đợi\n(Dẫu có bao vết thương anh vẫn đợi)\n\nAnh cũng chẳng thể hiểu ra đâu\nNhư lời thề này đã trao nhau\nVậy thì điều gì em phải buồn\nKhi anh vốn đã thuộc về em\n\nBabe your my darling oh\nMy darling oh\nDù cuộc đời đã cho ai lấy cắp trái tim em\nDẫu có bao vết thương anh vẫn đợi\n\nQuay về lại những phút ban đầu\nKhi mà mình chưa rõ tên nhau\nNguyện một lòng được yêu được chờ\nDù ngàn năm nữa anh vẫn bên em\n\nBabe your my darling oh\nMy darling oh\nDù cuộc đời đã cho ai lấy cắp trái tim em\nDẫu có bao vết thương anh vẫn đợi',
  ),
  Song(
    id: 20,
    title: 'Ánh mắt',
    artist: 'Shiki, Obito',
    coverImage: 'assets/images/__nh_m___t.png',
    assetPath: 'assets/audio/__nh_m___t.mp3',
    lyrics:
        'Dù nhiều cơn đau như thiêu chết\nBut anh vẫn không thể rời xa girl, anh không thể\nDù cho dao đâm hàng triệu nhát\nDẫu có bao vết thương anh vẫn đợi\n\nEm là người trong mỗi câu chuyện\nEm là chủ đề viết rất riêng\nVì em là một điều đặt biệt\nMà cả thế giới đang tìm nên là\nDẫu có bao vết thương anh vẫn đợi\n\nMy darling oh\nMy darling oh\nDù nhiều lần lặng im đến đau thắt trái tim anh\nDẫu có bao vết thương anh vẫn đợi\n(Dẫu có bao vết thương anh vẫn đợi)\n\nAnh cũng chẳng thể hiểu ra đâu\nNhư lời thề này đã trao nhau\nVậy thì điều gì em phải buồn\nKhi anh vốn đã thuộc về em\n\nBabe your my darling oh\nMy darling oh\nDù cuộc đời đã cho ai lấy cắp trái tim em\nDẫu có bao vết thương anh vẫn đợi\n\nQuay về lại những phút ban đầu\nKhi mà mình chưa rõ tên nhau\nNguyện một lòng được yêu được chờ\nDù ngàn năm nữa anh vẫn bên em\n\nBabe your my darling oh\nMy darling oh\nDù cuộc đời đã cho ai lấy cắp trái tim em\nDẫu có bao vết thương anh vẫn đợi',
  ),
  Song(
    id: 21,
    title: 'Có đôi điều',
    artist: 'Shiki',
    coverImage: 'assets/images/c_______i___i___u.png',
    assetPath: 'assets/audio/c_______i___i___u.mp3',
    lyrics:
        'Dù nhiều cơn đau như thiêu chết\nBut anh vẫn không thể rời xa girl, anh không thể\nDù cho dao đâm hàng triệu nhát\nDẫu có bao vết thương anh vẫn đợi\n\nEm là người trong mỗi câu chuyện\nEm là chủ đề viết rất riêng\nVì em là một điều đặt biệt\nMà cả thế giới đang tìm nên là\nDẫu có bao vết thương anh vẫn đợi\n\nMy darling oh\nMy darling oh\nDù nhiều lần lặng im đến đau thắt trái tim anh\nDẫu có bao vết thương anh vẫn đợi\n(Dẫu có bao vết thương anh vẫn đợi)\n\nAnh cũng chẳng thể hiểu ra đâu\nNhư lời thề này đã trao nhau\nVậy thì điều gì em phải buồn\nKhi anh vốn đã thuộc về em\n\nBabe your my darling oh\nMy darling oh\nDù cuộc đời đã cho ai lấy cắp trái tim em\nDẫu có bao vết thương anh vẫn đợi\n\nQuay về lại những phút ban đầu\nKhi mà mình chưa rõ tên nhau\nNguyện một lòng được yêu được chờ\nDù ngàn năm nữa anh vẫn bên em\n\nBabe your my darling oh\nMy darling oh\nDù cuộc đời đã cho ai lấy cắp trái tim em\nDẫu có bao vết thương anh vẫn đợi',
  ),
  Song(
    id: 22,
    title: 'Lướt trên con sóng',
    artist: 'Low G',
    coverImage: 'assets/images/l_____t_tr__n_con_s__ng.jpg',
    assetPath: 'assets/audio/l_____t_tr__n_con_s__ng.mp3',
    lyrics: 'Cả nhà ơi\nDangrangto đã quay trở lại rồi đây\nNói với mẹ là mẹ ơi mẹ đừng lo nhé\nCon đang mang về ngôi nhà vàng cả cây\nBước khỏi show cái nơi này toàn là bass và để lại một đám nhạc cháy xin lỗi do anh lại gây\nNói anh nghe nếu như không phải là anh thì điều gì là lý do giữ em ở lại đây babe\nKhiến cho em phải đứng hình vài giây\nEm muốn mình là người đẩy anh rơi vào tình si\nỞ bên ngoài giờ hàng giả tinh vi nên là anh phải tính kĩ mỗi bước chân mà mình đi\nHồi bé đâu ước làm nghề sửa điện mà giờ Big team tới đâu là thắp sáng hết cả city\nAnh mang tới đây mấy con flow giá trị\nVần câu này quá dị vậy còn lâu la chi mà chưa\nBật lên mà xem Lả Lướt anh xuất hiện\nĐang giật lên đằng trên trong cuộc đua\nCảm ơn người fans vì bài nào cũng thuộc lòng\nAnh cảm thấy mình oai như nhà vua\nĐến một ngày họ có thể nhăn và nheo nhưng anh tin cái Hip Hop nó sẽ không già nua\nTrận này mà thua phải hứng cả rổ cà chua thì anh em mình lại về nhà đi uống tà tưa\nKhông sao dù có những người họ ghét anh (ghét anh)\nAnh tin là họ thấy anh khác thường\nAnh cũng tin là những người ghét anh khi biết anh ra bài này lại thích anh phát cuồng\nAnh cũng từng là trái tim tan nát hết\nVì đam mê anh từng phải đi trát tường\nCó công mài sắt nên anh sẽ không bỏ cuộc\nĐừng bao giờ nói anh sẽ không làm được\nTức nước vỡ bờ\nLàm sao đầu đau cuồng quay thế nhờ\nVấp ngã phía trước khó khăn làm anh nào ngờ\nÁnh mắt phán xét thế gian ơ thờ (thế gian ơ thờ)\nCứ thế thấm thoắt mấy năm trôi vèo (trôi vèo)\nTự vươn mình lên để thoát kiếp nghèo (nghèo)\nNhớ khi họ chê anh chẳng làm theo\nChớ thấy sóng cả mà dã tay chèo\nTất cả những con sóng cứ thích xô vào anh\nTụi anh đang đến you better know it\nHah\nTurn up Trần Lả Lướt luôn hoan hỉ\nKhó với gian nan không sao đâu gọi là thêm gia vị\nAnh không cần phải canh để cảnh khổ quá đi\nNếu như mà phải chọn phe anh chọn Ferrari\nKhông nhụt chí (no)\nLuôn tham vọng (luôn tham vọng)\nÂm nhạc cần phải lit để trở nên lan rộng\nThôi thôi không cần giật tít đâu anh vẫn lên trang đầu\nChưa bao giờ rút ván anh cùng cả team qua cầu\nGiữa biển người anh là gã trai nghèo nhưng mà thấy sóng cả anh không ngã tay chèo\nSống tình cảm lướt con sóng bình thản họ cố tình cản anh vẫn cứ bay vèo\nBốn nón vàng họ nói giống bài bản chỉ ở Dangrangto cùng với đống tài sản\nNơi anh đặt chân họ cố trải thảm\nBoy quê xuất hiện cả phố phải hê\nVì có chông gai đời thêm sung sướng cảm ơn vì đã luôn vượt thường\nRap hai câu họ gọi anh thái tử\nNhìn vào đâu là cũng thấy thân thương\nNghĩ cái lúc mình bắt đầu\nNghĩ cách phải vươn phải hứa với mẹ ơi con sẽ không lầm đường\nLàm nhạc phải căng không tầm thường\nVì Trần Lả Lướt biết giữ cái lập trường\nChớ thấy sóng cả mà đã ngã tay chèo (woh)\nChớ thấy sóng cả mà đã ngã tay chèo\nChớ thấy sóng cả mà đã ngã tay chèo\nChớ thấy sóng cả mà đã ngã tay chèo\nCảm ơn những người tin mình\nCảm ơn những thích DRT chỉ cần tìm ở trong ví vẫn còn in hình\nCảm ơn vì bản thân càng mạnh hơn\nCảm ơn bao gian truân anh chưa biết gục\nCảm ơn vì đã nghe và nhận xét rằng anh đứng được ở đây vẫn chưa thuyết phục\nTừng câu và từng câu vẫn hằn sâu anh chỉ muốn mình được bay cao hơn nữa\nPhải đứng dưới bao nhiêu cơn mưa anh cũng đã dần cứng rắn hơn xưa\nChớ thấy sóng cả ngã cả tay chèo\nChẳng cơn sóng nào khiến anh ngã gục\nSay\nTức nước vỡ bờ\nLàm sao đầu đau cuồng quay thế nhờ\nVấp ngã phía trước khó khăn làm anh nào ngờ\nÁnh mắt phán xét thế gian ơ thờ (xét thế gian ơ thờ)\nCứ thế thấm thoắt mấy năm trôi vèo (eh yeah)\nTự vươn mình lên để thoát kiếp nghèo\nNhớ khi họ chê anh chẳng làm theo\nChớ thấy sóng cả mà dã tay chèo',
  ),
];
