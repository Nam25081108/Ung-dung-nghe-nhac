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
  ),
  Song(
    id: 14,
    title: 'Lan man',
    artist: 'Ronboogz',
    coverImage: 'assets/images/lan_man.jpg',
    assetPath: 'assets/audio/lan_man.mp3',
    lyrics:
        '\nEm thức giấc khi đêm muộn,\nQuăng chiếc tất lên trên giường\nNgân nga khúc nhạc em chọn \nChỉ để thiên đường càng thêm buồn\nEm bước chân ra đường \nBỏ lại suy nghĩ trên ga giường\nVà đi đến một nơi \nMà em biết chắc anh đang ở đây\n\nVà anh vốn chỉ là người cũng hay thức \nCố gắng cho lòng mình ngừng day dứt\nDùng cây bút từng giây phút\nAnh chỉ đại trà như người dùng Facebook\nAnh chỉ muốn ngủ ngon giữa đêm \nNhưng lại nhớ màu son của em \n\nVì nắng sẽ chẳng bên cạnh khi ta \nlại để nước mắt rơi\nEm có thấy gió đêm lạnh những lúc niềm đau đó cất lời?\nVì ta luôn luôn đi trễ chỉ trong vài giây để lỡ vòng tay cả đời\nVà anh chẳng muốn chỉ sống như vậy mà thôi \nĐể có em mỗi đêm về khi trên trời cao lắm bóng mây \nNếu mưa cứ rơi hoài thì căn phòng kia vẫn nóng nảy\nTa luôn có thì giờ dù em không muốn mình chờ đợi thêm\nAnh chỉ muốn được sống như vậy mà thôi \n\nĐừng đẩy nhau như nam châm chỉ vì ta trước giờ luôn luôn cùng cực \nAnh chỉ viết ra thang âm khi nhiều thứ vẫn kìm nén trong lòng ngực mình \nBao nhiêu suy nghĩ như cực hình, khiến em bực mình\nVậy thì thứ mà em cần đến là một cuộc tình\n\nAnh chỉ muốn dạo phố mỗi tối, khi niềm đau lên ngôi \nNên em đừng cố nói dối với từng câu trên môi \nNhững ai luôn tệ khi khiến em tuôn lệ \nChúng ta quên cách để buông nhẹ\nVậy thì ta sẽ biết điều đó trên đoạn đường về \n\nVì nắng sẽ chẳng bên cạnh khi ta \nlại để nước mắt rơi\nEm có thấy gió đêm lạnh những lúc niềm đau đó cất lời?\nVì ta luôn luôn đi trễ chỉ trong vài giây để lỡ vòng tay cả đời\nVà anh chẳng muốn chỉ sống như vậy mà thôi \nĐể có em mỗi đêm về khi trên trời cao lắm bóng mây \nNếu mưa cứ rơi hoài thì căn phòng kia vẫn nóng nảy\nTa luôn có thì giờ dù em không muốn mình chờ đợi thêm\nAnh chỉ muốn được sống như vậy mà thôi \n\nChỉ muốn cùng em đón ngọn gió đêm về\nEm như mặt trăng khi anh ở đâu thì anh cũng có em kề\nChỉ muốn cùng em say sưa vài lon\nUống cho đêm dài hơn\nMuốn say thêm vài cơn cùng em \n\nVì nắng sẽ chẳng bên cạnh khi em \nlại để nước mắt rơi\nEm có thấy gió đêm lạnh những lúc niềm đau đó cất lời?\nVì ta luôn luôn đi trễ chỉ trong vài giây để lỡ vòng tay cả đời\nVà anh chẳng muốn chỉ sống như vậy mà thôi \nĐể có em mỗi đêm về khi trên trời cao lắm bóng mây \nNếu mưa cứ rơi hoài thì căn phòng kia vẫn nóng nảy\nTa luôn có thì giờ dù em không muốn mình chờ đợi thêm\nAnh chỉ muốn được sống như vậy mà thôi',
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
    lyrics:
        'Cả nhà ơi\nDangrangto đã quay trở lại rồi đây\nNói với mẹ là mẹ ơi mẹ đừng lo nhé\nCon đang mang về ngôi nhà vàng cả cây\nBước khỏi show cái nơi này toàn là bass và để lại một đám nhạc cháy xin lỗi do anh lại gây\nNói anh nghe nếu như không phải là anh thì điều gì là lý do giữ em ở lại đây babe\nKhiến cho em phải đứng hình vài giây\nEm muốn mình là người đẩy anh rơi vào tình si\nỞ bên ngoài giờ hàng giả tinh vi nên là anh phải tính kĩ mỗi bước chân mà mình đi\nHồi bé đâu ước làm nghề sửa điện mà giờ Big team tới đâu là thắp sáng hết cả city\nAnh mang tới đây mấy con flow giá trị\nVần câu này quá dị vậy còn lâu la chi mà chưa\nBật lên mà xem Lả Lướt anh xuất hiện\nĐang giật lên đằng trên trong cuộc đua\nCảm ơn người fans vì bài nào cũng thuộc lòng\nAnh cảm thấy mình oai như nhà vua\nĐến một ngày họ có thể nhăn và nheo nhưng anh tin cái Hip Hop nó sẽ không già nua\nTrận này mà thua phải hứng cả rổ cà chua thì anh em mình lại về nhà đi uống tà tưa\nKhông sao dù có những người họ ghét anh (ghét anh)\nAnh tin là họ thấy anh khác thường\nAnh cũng tin là những người ghét anh khi biết anh ra bài này lại thích anh phát cuồng\nAnh cũng từng là trái tim tan nát hết\nVì đam mê anh từng phải đi trát tường\nCó công mài sắt nên anh sẽ không bỏ cuộc\nĐừng bao giờ nói anh sẽ không làm được\nTức nước vỡ bờ\nLàm sao đầu đau cuồng quay thế nhờ\nVấp ngã phía trước khó khăn làm anh nào ngờ\nÁnh mắt phán xét thế gian ơ thờ (thế gian ơ thờ)\nCứ thế thấm thoắt mấy năm trôi vèo (trôi vèo)\nTự vươn mình lên để thoát kiếp nghèo (nghèo)\nNhớ khi họ chê anh chẳng làm theo\nChớ thấy sóng cả mà dã tay chèo\nTất cả những con sóng cứ thích xô vào anh\nTụi anh đang đến you better know it\nHah\nTurn up Trần Lả Lướt luôn hoan hỉ\nKhó với gian nan không sao đâu gọi là thêm gia vị\nAnh không cần phải canh để cảnh khổ quá đi\nNếu như mà phải chọn phe anh chọn Ferrari\nKhông nhụt chí (no)\nLuôn tham vọng (luôn tham vọng)\nÂm nhạc cần phải lit để trở nên lan rộng\nThôi thôi không cần giật tít đâu anh vẫn lên trang đầu\nChưa bao giờ rút ván anh cùng cả team qua cầu\nGiữa biển người anh là gã trai nghèo nhưng mà thấy sóng cả anh không ngã tay chèo\nSống tình cảm lướt con sóng bình thản họ cố tình cản anh vẫn cứ bay vèo\nBốn nón vàng họ nói giống bài bản chỉ ở Dangrangto cùng với đống tài sản\nNơi anh đặt chân họ cố trải thảm\nBoy quê xuất hiện cả phố phải hê\nVì có chông gai đời thêm sung sướng cảm ơn vì đã luôn vượt thường\nRap hai câu họ gọi anh thái tử\nNhìn vào đâu là cũng thấy thân thương\nNghĩ cái lúc mình bắt đầu\nNghĩ cách phải vươn phải hứa với mẹ ơi con sẽ không lầm đường\nLàm nhạc phải căng không tầm thường\nVì Trần Lả Lướt biết giữ cái lập trường\nChớ thấy sóng cả mà đã ngã tay chèo (woh)\nChớ thấy sóng cả mà đã ngã tay chèo\nChớ thấy sóng cả mà đã ngã tay chèo\nChớ thấy sóng cả mà đã ngã tay chèo\nCảm ơn những người tin mình\nCảm ơn những thích DRT chỉ cần tìm ở trong ví vẫn còn in hình\nCảm ơn vì bản thân càng mạnh hơn\nCảm ơn bao gian truân anh chưa biết gục\nCảm ơn vì đã nghe và nhận xét rằng anh đứng được ở đây vẫn chưa thuyết phục\nTừng câu và từng câu vẫn hằn sâu anh chỉ muốn mình được bay cao hơn nữa\nPhải đứng dưới bao nhiêu cơn mưa anh cũng đã dần cứng rắn hơn xưa\nChớ thấy sóng cả ngã cả tay chèo\nChẳng cơn sóng nào khiến anh ngã gục\nSay\nTức nước vỡ bờ\nLàm sao đầu đau cuồng quay thế nhờ\nVấp ngã phía trước khó khăn làm anh nào ngờ\nÁnh mắt phán xét thế gian ơ thờ (xét thế gian ơ thờ)\nCứ thế thấm thoắt mấy năm trôi vèo (eh yeah)\nTự vươn mình lên để thoát kiếp nghèo\nNhớ khi họ chê anh chẳng làm theo\nChớ thấy sóng cả mà dã tay chèo',
  ),
  Song(
    id: 23,
    title: 'Intro (Mong Em Hạnh Phúc Suốt Cuộc Đời Này)',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/intro__mong_em_h___nh_ph__c_su___t_cu___c______i_n__y_.jpg',
    assetPath: 'assets/audio/intro__mong_em_h___nh_ph__c_su___t_cu___c______i_n__y_.mp3',
    lyrics: 'Từng phút anh mong nhớ em từng giờ\nChẳng muốn buông xuôi chẳng thôi đợi chờ\nLà trái tim anh vẫn mơ về ngày mà nơi bình yên em nói\nchúng ta sẽ bên cạnh nhau mãi mãi đến mai sau \nĐến bao khi cơn gió  thôi đưa\nDường như những cơn mơ này dẫu không phai nhạt \nThì đã đến lúc nhận ra \nTừng lời ca anh viết cho em cũng phải dừng lại.\nCất đi yêu thương đến sâu trong lòng\nVẫn riêng anh một mình phải tập dần những thói quen.\nTập quên hết câu chuyện rằng anh\nĐã từng thương nhớ em nhường nào\nTập quen những cơn mưa đổ xuống \nem chẳng còn nơi đây.\nThầm mong áng mây đi cùng em \nđưa về nơi gió hoa tràn đầy\nMong rằng em hạnh phúc suốt cuộc đời này..\nLà 2 chúng ta đã trải qua \nBao nhày vui cũng như ngày buồn.\nAnh xin lỗi vì đã để cho 2 hàng lệ em tuôn\nLời yêu cuối cho anh đặt tên\nThay bài ca viết lên bầu trời\nNgày đẹp nhất là ngày anh có em chẳng rời.',
    album: 'Từng ngày như mãi mãi',
  ),
  Song(
    id: 24,
    title: 'Từng ngày như mãi mãi',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/t___ng_ng__y_nh___m__i_m__i.jpg',
    assetPath: 'assets/audio/t___ng_ng__y_nh___m__i_m__i.mp3',
    lyrics: '2 giờ đêm đã buông \nEm còn đứng trước thềm \nĐôi bờ mi khẽ tuôn những câu nghẹn ngào.\nMưa cạnh em cứ bay\nXuyên vào đôi mắt này\nNhư chưa từng nói với anh lời chia tay.\nChuyện tình yêu đúng là đúng sai là sai \nĐâu thể là cả hai như vậy...\nAnh không muốn phải chạy trốn\nSự thật em mắt kề mắt môi kề môi với người anh chẳng hay\nAnh đành chấp nhận đặt lại con tim ở đây.\n\nAnh đã nhận ra kết cục\nTình yêu làm anh chết gục\nAnh muốn yêu em từng ngày dài như mãi mãi.\nGiờ coi là lời yêu thương kia đã nên câu\nNgười quay đi anh chẳng sao đâu\nChỉ mong em tìm được người em yêu đắm say như ngày hôm qua..\n\nBao lần anh nghĩ suy \nMình vươn lại nhau những gì?\nSương mờ che khuất đi những khi em cười.\nSau này không có anh\nNhư vậy thôi cũng đành\nEm phải tự biết yêu thương mình hơn xưa.\n\nAnh đã nhận ra kết cục\nTình yêu làm anh chết gục\nAnh muốn yêu em từng ngày dài như mãi mãi.\nGiờ coi là lời yêu thương kia đã nên câu\nNgười quay đi anh chẳng sao đâu\nChỉ mong em tìm được người em yêu đắm say.\nAnh phải học cách chấp nhận\nChưa khi nào anh hối hận\nVì ta đã trao nhau từng ngày đậm sâu như thế.\nLời yêu này dành cho em sẽ chẳng đổi thay\nChạy theo em đến mãi sau này.\nMơ ước đấy chôn vùi sâu bên trong trái tim không dành cho\nDù anh muốn yêu em nhiều hơn\nAnh muốn bên em nhiều hơn\nAnh muốn ôm em nhiều hơn nhưng chỉ còn trong vô vọng.\nBuông tiếng yêu nơi đầu môi\nTập buông cánh tay nhau mà thôi\nDù biết vẫn còn vương tên em đến muôn đời.\nYêu ánh sao đêm rực rỡ\nYêu đến khi tim vụn vỡ\nMuốn yêu em từng năm tháng trôi như mãi mãi\nSau này không có anh như vậy thôi cũng đành\nEm phải tự biết yêu thương mình hơn xưa..',
    album: 'Từng ngày như mãi mãi',
  ),
  Song(
    id: 25,
    title: 'Em ơi là em',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/em___i_l___em.jpg',
    assetPath: 'assets/audio/em___i_l___em.mp3',
    lyrics: 'Ngày qua ngày vẫn câu chuyện kể có ai đưa về\nNhững con đường muốn em đừng nhớ tên\nHoàng hôn thì cũng hơi hơi đẹp mà tiếng xe đông nghẹt\nLàm em không nghĩ suy được gì\n\nHàng cây đung đưa như nói với em rằng bên kia kìa\nCó hương thơm nhưng chưa phải là hoa sữa\nGiật mình đi qua ba bốn quán ăn mà em quen thuộc\nNhưng anh thì chưa có muốn dừng lại\n(Ơ sao em im đấy\nAnh làm cái gì ơ hay) \n\nVì em nói bao lần em không thích đi lòng vòng\nMà anh cứ đâu chịu cho em yên thế nhở\nNhiều khi nói không buồn đâu\nĐôi lúc không là có anh\nThì mãi chưa hiểu được em\n\nLà ai cứ luôn miệng bên nhau đến khi mình già\nMà em thấy anh chẳng còn yêu em nữa rồi\nNgày xưa mới quen thì luôn lo lắng em từng chút\nBây giờ cứ vô tâm vậy thôi\n\nMột ngày trời mây đen cho bão táp mưa dông\nCũng chẳng làm anh thấy mệt\nMà tại vì sao anh luôn bối rối mỗi khi em im lặng như thế\nTừng lời xin lỗi mà anh nói ra\nĐều oan thấu tới mây trời\nVẫn chẳng thể một lần làm lung lay trái tim người\n\nVì anh chẳng biết lý do em giận (bởi điều này là điều em nắm trong bàn tay)\nNào hay người cứ khiến anh thật đau đầu\nCòn anh nào chắc có yêu em đâu\nChẳng phải người thì cam đoan sẽ không là ai\nThế thôi em tạm tin anh nói ra điều giấu kín đây\n\nVì em nói bao lần em không thích đi lòng vòng\nMà anh cứ đâu chịu cho em yên thế nhở\nNhiều khi nói không buồn đâu\nĐôi lúc không là có anh\nThì mãi chưa hiểu được em\n\nLà ai cứ luôn miệng bên nhau đến khi mình già\nMà em thấy anh chẳng còn yêu em nữa rồi\nNgày xưa mới quen thì luôn lo lắng em từng chút\nBây giờ cứ vô tâm vậy thôi (úi giời suốt ngày nói)\n\nTại anh đấy\nKhiến cho em luôn giận anh mãi không thôi\nTại anh hết\nĐang trời mưa tự nhiên nắng\nTại anh đấy\nKhông nói ra nhưng anh phải biết sẽ làm gì (bao nhiêu lần rồi cứ)\nTại anh hết\nAnh chỉ yêu có mỗi em thôi (thôi thôi thôi)',
    album: 'Từng ngày như mãi mãi',
  ),
  Song(
    id: 26,
    title: 'Vì điều gì',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/v_____i___u_g__.jpg',
    assetPath: 'assets/audio/v_____i___u_g__.mp3',
    lyrics: 'Là bao ngày qua anh chẳng hay\nAnh chẳng biết sâu tận trong tâm trí em\nVẫn đang cứ nghĩ suy điều gì\nEm không thể trao anh niềm tin như lời nói\nEm lại chọn cách giấu đi\nHết những vấn vương mãi chưa lành\n\nNhiều lần thắc mắc anh nghĩ rằng\nDo em đã bên anh ta quá lâu\nHay do vết thương chẳng thể vá khâu\nNên anh cứ bắt mình phải tranh đấu\n\nTừng giọt nước mắt lăn dài\nDù anh không nhắc thêm về quá khứ đâu\nNhưng trong đôi mắt em thì lại là cứ sâu\nChẳng thể khiến em quay về thế giới muôn màu\n\nĐiều mà anh muốn là mình bên nhau\nCùng em thức trắng kể cả đêm thâu\nNhiều lần cố gắng gọi tên\nCho dù em chẳng quên những u sầu\n\nNgười ta lo lắng điều gì thêm đâu?\nBỏ mặc kí ức lại để em lau\nĐiều anh ta nói thương xuyên\nYêu mình em lại là yêu rất yêu cầu\n\nVà nếu như việc bên cạnh anh là sai\nThì sao cơn mưa cứ vương má em hoài?\nEm đã tự cho mình thêm lần hai\nThì còn điều gì cố níu giữ em lại\n\nDặn anh phải luôn mộng mơ trong rạn vỡ\nAnh cũng chỉ mong người luôn rạng rỡ\n"Khi tia nắng kia thắp lên bầu trời\nChiếu xuống đây soi mắt hoen em cười"\n\nLà bao ngày qua anh chẳng hay\nAnh chẳng biết sâu tận trong tâm trí em\nVẫn đang cứ nghĩ suy điều gì\nEm không thể trao anh niềm tin như lời nói\nEm lại chọn cách giấu đi\nHết những vấn vương mãi chưa lành\n\n(Dangrangto)\n"Lả Lướt"\nBabe anh không rõ trong em còn ai từ lâu\nNhớ hay không chẳng nói một câu gì\nActing fine như là chuyện thường\nChạy tới bên anh do em tiện đường\nƯớc anh có thể phũ phàng hơn\nCũng ước em cho anh được yêu một lần\nGiá như tất cả là thật lòng\nCòn nếu không vui thì anh cũng không cần\nVậy mà tại sao anh luôn cứ hay đâm đầu vào điều không nên\nTrăm khúc hát cũng như trăm lá thư anh trao tương tư để cho em\nNguyện dành trọn riêng em, nhưng lại chẳng phải nơi em muốn tìm đến\nKhi bên anh em lại tương tư ai\nEm ơi chặng đường dài này chẳng mấy khi lâu bền\n(Rối bời, anh ngoảnh lại là vì điều chi)\n(Nuông chiều, dù không cho em được ngắm những diệu kỳ)\n(Nhớ thật nhiều, nụ hôn em give it back to me)\nChấp nhận sẽ không thêm một lần (Nghĩ)\n\n(buitruonglinh)\nVà nếu như việc bên cạnh anh là sai\nThì sao cơn mưa cứ vương má em hoài?\nEm đã tự cho mình thêm lần hai\nThì còn điều gì cố níu giữ em lại\n\nDặn anh phải luôn mộng mơ trong rạn vỡ\nAnh cũng chỉ mong người luôn rạng rỡ\n\nHoàng hôn dần buông bên cạnh anh\nNhưng lại nhớ khi màn mưa kia mãi tuôn\nKhiến em cứ mang theo u buồn\nNgười chẳng thể nào bỏ buông hết đi\nVì con tim trót ghi tên một người đã lỡ',
    album: 'Từng ngày như mãi mãi',
  ),
  Song(
    id: 27,
    title: 'Từng ngày yêu em',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/t___ng_ng__y_y__u_em.jpg',
    assetPath: 'assets/audio/t___ng_ng__y_y__u_em.mp3',
    lyrics: 'Lại chìm trong đôi mắt em \nXoe tròn ngất ngây\nPhút giây khi mà anh khẽ nhìn sang\nLại làm đôi môi nhớ em\nLại muốn hôn em thêm bao lần\nTừng ngày cô đơn rẽ đôi hạ thu đông khẽ trôi\nCạnh bên em anh sẽ thôi u sầu\nLại làm cho anh cảm thấy yêu em hơn ngày qua\n\nChẳng phải gió cuốn mưa bay \nĐưa đôi tay đón anh về ngày lời yêu cất lên\nChỉ cần thức giấc khi bên em nơi anh thấy yên bình\nBiển rộng sông sâu\nAnh trót thương chỉ riêng mình em thôi đấy\nTình yêu ấy chẳng hề đổi thay\nDù là bao lâu cảm xúc trong anh mãi đong đầy\n\nVội lạc vào giấc mơ\nNhẹ nhàng tựa ý thơ\nNụ cười người để anh nhớ để anh mong đợi\nSợ một ngày ngát xanh\nCuộc đời này vắng em anh phải làm sao bây giờ\nEm này em biết chăng\nBao ngày và tháng năm\nChỉ cần một lần say đắm\nSẽ in hằn sâu trong tâm trí\nMãi như vậy\nNhư lời hứa yêu em\nYêu mình em một đời',
    album: 'Từng ngày như mãi mãi',
  ),
  Song(
    id: 28,
    title: 'Nàng công chúa nhỏ',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/n__ng_c__ng_ch__a_nh___.jpg',
    assetPath: 'assets/audio/n__ng_c__ng_ch__a_nh___.mp3',
    lyrics: 'Lời 1:\nNghiêng bờ vai để mái tóc sáng rực lên\nEm tựa như là thiên thần\nNhư là muôn vì sao giữa khung trời đêm\nRung động anh biết bao lần\n\nTrái tim anh lạc lối rồi\nHãy giữ nụ cười đó trên môi\nVì em là nàng công chúa nhỏ\nCòn trông đợi gì thêm nữa nhờ?\n\nMình cùng nhau đi qua\nNhững vùng đất ta chưa đặt tên\nNgắm khoảnh khắc ban mai vừa lên\nCon đường sát bên khu rừng\nVượt qua hết núi cao đến nơi lâu đài\nTa lại hát thêm bao bài ca\nTay nàng dắt theo muôn loài hoa\nTrong từng phút giây thiên đàng em à có biết?\n\nLời 2:\n\nMỗi khi cạnh bên anh\nEm không cần che giấu đi ước mơ\nCứ nói đi đừng suy nghĩ\nĐiều em muốn là điều anh mong\n\nĐến bao giờ mặt trời mỗi sáng\nChẳng còn chiếu soi nơi đây\nThì cũng mặc kệ đi chứ\nĐiều anh muốn là làm em vui\n\nBởi vì anh đã yêu đôi mắt em say thật say\nYêu từ lúc mình tay cầm tay\nYêu nụ hôn ngọt hơn trời mây\nQuên hết đi bao đêm ngày\n\nÁnh trăng dẫn ta tới muôn lối\nĐưa vầng dương cùng em dạo chơi\nSông thời gian dần trôi chậm trôi\nVẫn cứ bên nhau như vậy\n\nĐi qua vùng đất ta chưa đặt tên\nNgắm khoảnh khắc ban mai vừa lên\nCon đường sát bên khu rừng\nVượt qua hết núi cao đến nơi lâu đài\nTa lại hát thêm bao bài ca\nTay nàng dắt theo muôn loài hoa\nTrong từng phút giây thiên đàng em à có hay?',
    album: 'Từng ngày như mãi mãi',
  ),
  Song(
    id: 29,
    title: 'Đi cùng anh',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/__i_c__ng_anh.jpg',
    assetPath: 'assets/audio/__i_c__ng_anh.mp3',
    lyrics: 'Lời 1:\nCầm tay anh nhé!\nKhông còn ai níu chân ta\nĐi về phía ánh dương tà\nVì yêu anh sẽ\nĐi cùng em dẫu bao xa\n\nChẳng cần suy nghĩ\nTa bỏ quên những gì\nChạy theo cơn gió ru em thôi bận lòng\nPhiền lo hãy cứ ngủ yên ngủ yên\n\nKìa em có thấy không?\nĐại dương mênh mông xanh ngát kia\nSâu tận tới đáy lòng\nTừ hôm qua khi hai má em\nVẫn hằn sâu mấy dòng lệ tuôn rơi\nNhìn em tổn thương làm con tim anh vụn vỡ\n\nGiờ ta cứ bước đi\nMình như những đứa nhóc\nVẫn giữ lấy ước mơ trước khi màn đêm xuống\nNgày làm hạ vương mùa thu rơi\nChỉ cần mình bên cạnh nhau thôi\nChỉ cần anh vẫn trông thấy em tươi cười\nMình đi đến đâu cũng được\n\nĐi là đi cùng anh hết\nNhững con đường ngang dọc\nRồi đi rồi đi thật lâu\nGiờ cũng đâu có còn quan trọng\nVì em đang ngồi sau người em yêu nhất\nTựa lên đôi bờ vai\nMà em thương nhớ bao nhiêu lần\n\nYêu để cho vầng trăng sáng\nPhía chân trời cao rộng\nMình yêu để cho ngày xuân xanh\nMãi phút giây ta cùng với nhau (nono nonono)\nDù có đi về đâu thì em vẫn phía sau anh mà\n\nLời 2:\n[52Hz]\nBầu trời rộng lớn\nĐại dương chỉ lối ta đi\nVề vùng trời mới\nChỉ còn hai đứa mình\nNơi mà trái tim ôm trọn nắng mai\nĐể sưởi ấm đôi ta\nKhỏi buốt giá từng đêm\n\nĐón lấy tiếng ca vang\nNhắm mắt ngóng thu sang\nNắm chút gió lang thang\nĐi khỏi những nỗi đau ta đang mang\nNơi mà trái tim ôm trọn nắng mai\nĐể sưởi ấm đôi ta\nChẳng đâu là quan trọng\n\n[Buitruonglinh]\nChờ hoàng hôn xuống áng thơ này phiêu bồng\nTừng lời em nói khiến anh lại siêu lòng\nCho anh dắt tay người về một nơi\nChỉ còn có mỗi riêng anh và em\n\nBầu trời rộng lớn ánh sao này chan hòa\nCùng niềm vui trái tim như được mang quà\nChẳng cần lo lắng từ nay về sau\nKhi ta cùng nhau trải qua những giấc mơ trong đời\n\nĐi là đi cùng anh hết\nNhững con đường ngang dọc\nRồi đi rồi đi thật lâu\nGiờ cũng đâu có còn quan trọng\nVì em đang ngồi sau người em yêu nhất\nTựa lên đôi bờ vai\nMà em thương nhớ bao nhiêu lần\n\nYêu để cho vầng trăng sáng\nPhía chân trời cao rộng\nMình yêu để cho ngày xuân xanh\nMãi phút giây ta cùng với nhau (nono nonono)\nDù có đi về đâu thì em vẫn phía sau anh mà',
    album: 'Từng ngày như mãi mãi',
  ),
  Song(
    id: 30,
    title: 'Anh chưa từng hết yêu',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/anh_ch__a_t___ng_h___t_y__u.jpg',
    assetPath: 'assets/audio/anh_ch__a_t___ng_h___t_y__u.mp3',
    lyrics: 'Vết mực anh viết ra cũng đã cạn \nkhô từng dòng nhớ thương \nAnh ước cho ngày mà anh mất em chưa bao giờ đến \nMơ mộng dần vỡ tan giống như chuyện ta còn đang dở dang \nAnh biết sẽ chẳng thể nào gom lại thời gian lúc ban đầu \n\nNgàn lời yêu khi ấy tràn đầy trong mắt anh \nNhững hy vọng mong manh \nCùng nhau tới biển trời dẫu biết mai muôn trùng xa cách \nMàn đêm đen giờ như vây kín thêm \nMang niềm đau nén sâu trong dòng thư \nGửi lại em khi ngày đẹp nhất \n\nVì những năm tháng sau này \nGiống như chưa từng yêu anh \nChắc em sẽ thôi đau buồn \nĐóa hoa kia rực rỡ chẳng thể vượt qua bão giông \nChuyện mình rồi thì cũng sẽ như vậy \nNày gió bay tới phương nào nhắn đôi lời dặn trời xanh \nHãy thay thế tôi yêu người \nMai rồi anh phải bỏ quên lại quá khứ \nQuên rằng anh đã từng nói hết yêu em \nChưa một lần anh từng thấy hết yêu em (ver 2)\n\nVer 2\nDẫu ở muôn ngàn lặng yên anh vẫn sẽ dõi theo \nMuốn thấy khi em hạnh phúc \n\nLời chia tay mà anh chẳng hề muốn nói ra \nCắt sâu vào trong tim vụn vỡ đến tận cùng \nKhiến em không bao giờ tha thứ \nVì em có cả tuổi xuân ngóng chờ \nSao mà anh nỡ thấy em nhạt nhòa \nCạnh bên anh khi ngày anh mất',
    album: 'Từng ngày như mãi mãi',
  ),
  Song(
    id: 31,
    title: 'Chỉ là không có nhau',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/ch____l___kh__ng_c___nhau.jpg',
    assetPath: 'assets/audio/ch____l___kh__ng_c___nhau.mp3',
    lyrics: 'Lời 1:\nNgày lại ngày trôi qua\nAnh suy tư với những câu chuyện đường dài\nCuộc sống anh ước anh mơ\nĐợi chờ cho đến bao giờ\n\nNgày lại ngày trôi nhanh\nEm loay hoay với những lo toan mệt nhoài\nTa cứ ước chi, từng bước đi, đừng ướt mi\nTháng ngày cũng sẽ lướt đi thôi\n\nVà rồi, anh gặp em như thế\nTừng ngày trôi, ta đậm sâu từ lúc nào có hay\nThời gian chỉ cần được ở bên nhau\nMặc kệ mọi thứ mai sau thế nào\nGiờ ta có tất cả\nMà chẳng thể giữ lấy nhau\n\nVì sao hai ta yêu như vậy mà\nLại cùng buông tay nhau trong một giây\nNhìn nhau cứ cố cứng rắn đứng im lặng ngày hôm ấy\nChẳng phải vì anh thương em chưa thật lòng\nCảm xúc trong tim vỡ tan cứ thế gọi tên\nMột ngày trời nắng khô mây tàn\nGió gieo muôn vàn lời yêu chìm trong nước mắt\n\nTa có tất cả\nChỉ là không có nhau\nTa có tất cả\nChỉ là không có nhau\nLời 2:\n\nVà rồi, ta rời xa như thế\nCòn cầm tay, đã lạc nhau từ lúc nào có hay\nChẳng thể cùng vượt hoạn nạn biển giông\nGiờ lại phải đứng trước nhau lúc này\nGiờ ta có tất cả\nMà chẳng thể giữ lấy nhau\n\nVì sao hai ta yêu như vậy mà\nLại cùng buông tay nhau trong một giây\nNhìn nhau cứ cố cứng rắn đứng im lặng ngày hôm ấy\nChẳng phải vì anh thương em chưa thật lòng\nCảm xúc trong tim vỡ tan cứ thế gọi tên\nMột ngày trời nắng khô mây tàn\nGió gieo muôn vàn lời yêu chìm trong nước mắt\n\nTrả lại anh giấc mơ\nTrả lại em chiếc hôn môi đầu\nTrả lại nhau ngày yêu say đắm mộng mơ\nKhông mang lo âu\n\nTa có tất cả\nChỉ là không có nhau\nTa có tất cả\nChỉ là không có nhau\n(nhìn nhau lặng im hai ta vỡ tan như vậy)\n\nGiờ anh có tất cả\nLại để lạc mất em\nTa có tất cả\nMà chẳng thể giữ lấy nhau\n\nTa có tất cả\nChỉ là không có nhau\nTa có tất cả\nMà chẳng thể giữ lấy nhau',
    album: 'Từng ngày như mãi mãi',
  ),
  Song(
    id: 32,
    title: 'Dù em từng yêu',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/d___em_t___ng_y__u.jpg',
    assetPath: 'assets/audio/d___em_t___ng_y__u.mp3',
    lyrics: 'Dù em từng yêu thiêu đốt hết con tim\nChỉ nhận lại là tổn thương\nNước mắt em còn nhiều nữa đâu\nMà cứ phải khóc trong những đêm sầu\nKhi mà nắng lên rồi\nNhững câu ca còn phía xa nơi chân trời\nMuộn phiền trong em sẽ thôi đợi mong\n\nLời 1:\nTừng lời xin lỗi thốt ra thật nhẹ nhàng như thế\nĐã bao lần em cứ phải lắng nghe như vậy\nLại là những lí do để em một mình cô đơn\nCó lẽ giờ đây đã đến lúc em nhận ra\n\nLà khi đôi mắt em đang một lần nữa\nKhóc than cho bao niềm đau em mang\nCái cách em nhớ về những kỉ niệm\nLà đang làm hại bản thân\nTha thứ cho qua màn đêm tối\nHát vang với mây trời nở trên môi\nHãy cứ vô tư vì em nào đâu có lỗi?\n\nDù em từng yêu thiêu đốt hết con tim\nChỉ nhận lại là tổn thương\nEm đã không còn tin thế gian này\nCó thể giúp em thấy phép màu\nKhi mà mắt em chẳng\nThiết tha thêm lời hứa dối gian nữa rồi\nCứ thu mình lại như thế\nCứ co ro góc riêng trong lòng\n\nNào tươi cười lên anh biết em sẽ buồn\nThế nhưng ngày trôi rất nhanh\nAnh muốn em tự mình đứng lên\nĐể thôi lạc lối trong những nghi ngờ\nKhi mà nắng lên rồi\nNhững câu ca còn phía xa nơi chân trời\nMuộn phiền trong em sẽ thôi đợi mong\n\n\nLời 2:\n\nCó thì tốt không cũng chẳng sao\nKhi mà cứ đến rồi cũng sẽ đi\nBao lần thời gian vô tình cứ trôi\nVẫn khiến cho đôi vai em yếu mềm như thế\n\nSẽ không bao giờ mình trở lại như là lần đầu\nĐành tìm mọi cách chỉ để lãng quên nhau\nTình yêu nào càng đậm sâu\nLại càng muốn đem thêm u sầu\n\nLà khi đôi mắt em đang một lần nữa\nKhóc than cho bao niềm đau em mang\nCái cách em nhớ về những kỉ niệm\nLà đang làm hại bản thân\nCứ luôn kiếm tìm những tia hy vọng nhỏ nhoi\nĐâm sâu vào mảnh ký ức vỡ tan\nKhiến em càng chịu thêm tổn thương\n\nQuên sạch đi hết ngày mai\nCòn đón chờ em phía trước\nCon đường em bước từ nay\nChẳng còn nước mắt trên mi\nEm phải luôn luôn thật xinh\nPhải tự yêu lấy nơi bản thân mình\nĐể một lần em được là chính em\nChẳng thể đau lòng vì ai nữa\n\nDù em từng yêu thiêu đốt hết con tim\nChỉ nhận lại là tổn thương\nEm đã không còn tin thế gian này\nCó thể giúp em thấy phép màu\nKhi mà mắt em chẳng thiết tha\nThêm lời hứa dối gian nữa rồi\nCứ thu mình lại như thế\nCứ co ro góc riêng trong lòng\n\nNào tươi cười lên anh biết em sẽ buồn\nThế nhưng ngày trôi rất nhanh\nAnh muốn em tự mình đứng lên\nĐể thôi lạc lối trong những nghi ngờ\nKhi mà nắng lên rồi\nNhững câu ca còn phía xa nơi chân trời\nMuộn phiền trong em sẽ thôi đợi mong\n\nQuên sạch đi hết ngày mai\nCòn đón chờ em phía trước\nCon đường em bước từ nay\nChẳng còn nước mắt trên mi\nEm vẫn luôn luôn đẹp xinh\nBiết lắng nghe con tim mình\nLà em đã cố gắng yêu hết sức rồi',
    album: 'Từng ngày như mãi mãi',
  ),
  Song(
    id: 33,
    title: 'Giờ thì',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/gi____th__.jpg',
    assetPath: 'assets/audio/gi____th__.mp3',
    lyrics: '[Verse 1]\nMỉm cười mỗi lúc thấy tiếng nói em ngay bên cạnh\nGiữa tiếng pháo đón mưa đêm đêm lạnh\nHai ta trao nụ hôn êm đềm\nNhẹ thắp ánh sao tựa lên\nCùng vượt qua những sóng gió, khó khăn bao cơ hội\nCũng đã muốn nói ra câu yêu rồi\nTay trong tay cùng nhau đi về\nNhẹ bước trong tim nửa kia\nRồi tháng ngày phai nhạt cho kí ức phôi pha\nMình lỡ để danh vọng đứng giữa chúng ta\nCho anh quay lại khoảnh khắc ấy, để anh cố níu tay em lại\n\n[Chorus]\nGiờ thì mình đã không còn thương, không còn đau, không còn vì nhau nữa\nCũng đã từng mang nhiều điều mong ước nhưng đành xa xôi\nBỏ quên những giấu yêu bao ngày ở lại đằng sau\nTa bước tiếp trên đoạn đường chẳng có nhau\nNỗi đau ấy rồi sẽ thay bằng niềm hạnh phúc của riêng mỗi người\nRồi mình sẽ trưởng thành hơn, kiên cường hơn, không còn như lúc trước\nEm sẽ dần quên từng đêm khóc nấc trên đôi vai này\nNgày em có đến bên ai trong đời\nThật tâm vẫn chúc em luôn vui cười\nVì anh yêu em rất nhiều, chỉ là chúng ta chọn rời xa\n[Verse 2]\nDù sao hai ta cũng đã dành trọn cho nhau tất cả\nTừng lời đậm sâu thế đã đủ rồi\nMột lần anh không hối tiếc\nVì dù gì anh cũng biết sẽ chẳng thể luôn mơ về em mãi\nVậy nên anh thôi cố chấp chỉ đứng phía xa để ôm trọn bầu trời đêm\nĐẹp như mắt em ngày đầu\nKhi em nói câu yêu anh\n\n[Chorus]\nGiờ thì mình đã không còn thương, không còn đau, không còn vì nhau nữa\nCũng đã từng mang nhiều điều mong ước nhưng đành xa xôi\nBỏ quên những dấu yêu bao ngày ở lại đằng sau\nTa bước tiếp trên đoạn đường chẳng có nhau\nNỗi đau ấy rồi sẽ thay bằng niềm hạnh phúc của riêng mỗi người\nRồi mình sẽ trưởng thành hơn, kiên cường hơn, không còn như lúc trước\nEm sẽ dần quên từng đêm khóc nấc trên đôi vai này\nNgày em có đến bên ai trong đời\nThật tâm vẫn chúc em luôn vui cười\nVì anh yêu em rất nhiều, chỉ là chúng ta chọn rời xa\n\n[Outro]\nNgày em có đến bên ai trong đời\nThật tâm vẫn chúc em luôn vui cười\nVì anh yêu em rất nhiều, chỉ là chúng ta chọn rời xa\n\n',
    album: 'Từng ngày như mãi mãi',
  ),
  Song(
    id: 34,
    title: 'Điều làm anh vui',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/__i___u_l__m_anh_vui.jpg',
    assetPath: 'assets/audio/__i___u_l__m_anh_vui.mp3',
    lyrics: 'Là hạnh phúc chẳng thể giấu\nKhi anh được chạm vào mái tóc này\nNhẹ như tia nắng bay\nLời yêu em đắm say\nLà anh may mắn\nHay do bao ngày\nAnh đã trông mong\nĐể thấy em khẽ sang nhìn anh\nMình đã bên cạnh nhau lâu rồi\nLại nhớ em từng đêm thâu ngồi\nĐể ngắm lại phần ký ức anh cất\nAnh muốn giữ mãi thôi không rời\nMặc cho ngàn sóng gió trên đời\nTrải qua niềm đau\nVụn vỡ không nên lời\nMọi điều dường như nhẹ nhàng\nKhi trông thấy em\nVà lòng anh chợt vui lên\nMỗi khi chân trời ngát xanh\nTrông về phía anh em cười\nLà khi tình yêu\nNgân nga khúc ca\nViết riêng của hai đứa mình\nNắm tay đi muôn nơi\nChờ bình minh lên\nKhi anh có em\nNhững suy tư còn vướng trên vai\nGiờ là chỗ em nghiêng đầu\nThầm mong thời gian trôi qua\nChúng ta vẫn luôn là như thế này\nVẫn bên nhau chẳng thể rời xa\nVà anh sẽ luôn nói yêu em\nVà vẫn yêu em\nVà mãi yêu em\nYêu mình em chẳng đổi thay\nCho dù đến sau này\nThì điều khiến anh vui\nLà thấy mỗi ban mai\nEm mỉm cười như thế thôi\nMình đã bên cạnh nhau lâu rồi\nLại nhớ em từng đêm thâu ngồi\nĐể ngắm lại phần ký ức anh cất\nAnh muốn giữ mãi thôi không rời\nMặc cho ngàn sóng gió trên đời\nTrải qua niềm đau\nVụn vỡ không nên lời\nMọi điều dường như nhẹ nhàng\nKhi trông thấy em\nVà lòng anh chợt vui lên\nMỗi khi chân trời ngát xanh\nTrông về phía anh em cười\nLà khi tình yêu\nNgân nga khúc ca\nViết riêng của hai đứa mình\nNắm tay đi muôn nơi\nChờ bình minh lên\nKhi anh có em\nNhững suy tư còn vướng trên vai\nGiờ là chỗ em nghiêng đầu\nThầm mong thời gian trôi qua\nChúng ta vẫn luôn là như thế này\nVẫn bên nhau chẳng thể rời xa\nVà lòng anh chợt vui lên\nMỗi khi chân trời ngát xanh\nTrông về phía anh em cười\nThầm mong thời gian trôi qua\nChúng ta vẫn luôn là như thế này\nVẫn bên nhau chẳng thể rời xa\nVà anh sẽ luôn nói yêu em\nVà vẫn yêu em\nVà mãi yêu em\nYêu mình em chẳng đổi thay\nCho dù đến sau này\nThì điều khiến anh vui\nLà thấy mỗi ban mai\nEm mỉm cười như thế thôi',
    album: 'Vọng',
  ),
  Song(
    id: 35,
    title: 'Nếu em còn đợi anh',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/n___u_em_c__n______i_anh.jpg',
    assetPath: 'assets/audio/n___u_em_c__n______i_anh.mp3',
    lyrics: 'Em vẫn yên lặng trong góc tối, vẫn tìm kiếm lý do\nDù cho anh có hết yêu, có buông tay\nNụ cười em đã trót trao bỗng quay lại như chưa qua bão giông\nChợt nhận ra em yếu đuối thế nào\n\nVẫn bao ngày chân cứ đứng run run bên cạnh hàng cây đã thay màu\nĐợi rồi trông có khi ta nhìn thấy nhau\nMưa ở nơi xa quá không đủ gần để sưởi ấm đôi tay\nNhẹ làn sương khuất lấp em nơi này\n\nMình yêu nhau ai nào đâu biết trước ngày đôi mình lệch chân bước\nLiệu anh có đứng yên anh chờ\nGiống như em dành trọn cho anh yêu thương bấy lâu chẳng cần đắn đo\nDù cho xa nhau là không thấy nữa không còn bên nhau nữa thì em vẫn đứng đây em đợi\nĐợi cho mắt không còn màu biếc xanh những lời hẹn thề với anh \n\nTình yêu còn níu kéo dứt vang vọng hay chưa\nChỉ còn lại mình em nhận lấy nhưng sao không vừa\nThầm thương lời anh nói chẳng nguyên vẹn như xưa .. Đã hứa\n\nGiờ em chẳng muốn tiếc hết duyên tình em trao\nNguyện đem cả thanh xuân đổi lấy những cơn mưa rào\nAnh có cùng đi tiếp nếu em còn đợi anh \nAnh ơi !!! \n\nMột mình bao lâu để chờ tia nắng chiếu xuyên màn đêm dài \nNgỡ như từng chiếc hôn còn vương lưu luyến mãi chưa phai \nLiệu rằng ngày mai còn hoài thương nhớ \nLòng nhạt phai vì ai không nỡ\nChỉ là em giờ đây đã lỡ yêu rồi vỡ tan\nLàm cho đôi mắt nhòe đi, khi cơn mưa kia vương vấn đôi mi  \nDở dang em tiếc làm chi , mong ban mai lên sẽ cuốn trôi đi\nNghẹn ngào xuôi dần theo lý trí để bình yên thay thế đôi ta \nTừng đậm sâu rồi cũng sẽ mau phôi pha\n\nĐã bao lần em mong ước sẽ luôn được dựa bờ vai ấy sau này \nDựa cơn mơ mỗi khi em ngồi nhớ anh, anh à\nSao giờ anh không ở bên em để lặng nghe những tâm tư\nCủa người con gái trót yêu anh rồi\n\nMình yêu nhau ai nào đâu biết trước ngày đôi mình lệch chân bước\nLiệu anh có đứng yên anh chờ\nGiống như em dành trọn cho anh yêu thương bấy lâu chẳng cần đắn đo\nDù cho xa nhau là không thấy nữa không còn bên nhau nữa thì em vẫn đứng đây em đợi\nĐợi cho mắt không còn màu biếc xanh những lời hẹn thề với anh \n\nTình yêu còn níu kéo dứt vang vọng hay chưa\nChỉ còn lại mình em nhận lấy nhưng sao không vừa\nThầm thương lời anh nói chẳng nguyên vẹn như xưa .. Đã hứa\n\nGiờ em chẳng muốn tiếc hết duyên tình em trao\nNguyện đem cả thanh xuân đổi lấy những cơn mưa rào\nAnh có cùng đi tiếp nếu em còn đợi anh \nAnh ơi !!! \n\nGiờ em chẳng muốn tiếc hết duyên tình em trao\nNguyện đem cả thanh xuân đổi lấy những cơn mưa rào\nAnh có cùng đi tiếp nếu em còn đợi anh \nAnh ơi !!!',
    album: 'Vọng',
  ),
  Song(
    id: 36,
    title: 'Lời yêu',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/l___i_y__u.jpg',
    assetPath: 'assets/audio/l___i_y__u.mp3',
    lyrics: 'Trộm nhìn em bao nhiêu lần\nĐể nhẹ lòng trong nỗi yêu thầm\nChẳng thể với lấy\nKhi là giấc mơ quá xa xôi\nTrộm nhìn mái tóc buông dài\nCả ngàn lần cũng chẳng nguôi ngoai\nChỉ chìm vào sâu trong cơn đắm say\nRiêng mình mỗi em\nDa da da\nYêu anh yêu đôi mắt khẽ cười\nKhi lướt qua thật nhanh\nYêu cơn mưa rơi trên bờ vai gầy\nYêu anh yêu con phố ướt nhòe\nNơi ngã tư đèn xanh\nYêu đôi tay em hứng giọt mưa đầy\nKhi hoàng hôn buông xuống\nEm buông nhẹ đôi mi\nBao buồn đau anh giấu\nTheo ngày dài trôi đi\nYêu anh yêu từng giây thấy em\nMong nói ra lời thương\nSâu trong thâm tâm anh mà thôi\nDệt những yêu thương kia thành lời ca\nDệt trong lòng ta tia nắng mới\nGộp những câu ca cho nặng lời yêu\nMà chưa một lần em biết tới\nBởi vì anh chẳng dám nói hết ra\nNhững gì mà anh nghĩ suy\nSợ rằng em sẽ cách xa anh\nSợ cơn giông ập xuống\nAnh mất đi tia hi vọng duy nhất thôi\nLời yêu dấu/giấu riêng mình mỗi anh\nAnh toàn thu mình\nVào trong bao lắng lo mệt nhoài\nƯu phiền trên vai\nChẳng thể đợi chờ tương lai\nEm thì luôn xinh đẹp\nNhư muôn đóa hoa ngọt ngào\nTự hỏi vì sao\nNàng phải lựa chọn thương ai\nBầu trời đêm cứ yên bình\nNgàn vì sao vẫn lung linh\nChỉ còn lại mỗi anh\nChẳng thể ngưng nghĩ suy về em\nTự đặt ra những câu hỏi\nDù ngày mai có phai phôi\nNguyện cho vay trái tim\nMà chẳng cần thiết em trả lời\nBao ngày anh trông ngóng\nBao nhiêu lần anh mong\nEm là điều duy nhất\nĐem bình yên bên trong\nYêu anh yêu từng giây thấy em\nMong nói ra lời thương\nSâu trong thâm tâm anh mà thôi\nDệt những yêu thương kia thành lời ca\nDệt trong lòng ta tia nắng mới\nGộp những câu ca cho nặng lời yêu\nMà chưa một lần em biết tới\nBởi vì anh chẳng dám\nNói lên câu yêu người\nMặc cho bao vấn vương\nThiêu đốt con đường về\nVì một mình anh vẫn thế\nCuộn sâu trong trái tim\nSợ em quay bước đi\nChỉ cần anh còn thấy\nTrên môi em cười\nLà bao nhiêu xót xa\nCũng đã vơi đi rồi\nTrời mưa giông ngập lối\nMùa đông như khẽ trôi\nLặng nhìn em mãi thôi\nYêu anh yêu đôi mắt khẽ cười\nKhi lướt qua thật nhanh\nYêu cơn mưa rơi trên bờ vai gầy',
    album: 'Vọng',
  ),
  Song(
    id: 37,
    title: 'Yêu người có ước mơ',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/y__u_ng_____i_c________c_m__.jpg',
    assetPath: 'assets/audio/y__u_ng_____i_c________c_m__.mp3',
    lyrics: 'Bình minh đến với những mịt mờ\nLàm sao thấy đường để tìm thấy nhau\nTự biết sẽ mau xa rời chỉ mình anh với bao nhiêu nghĩ suy\nTừ những ánh mắt nụ cười cho cơn gió lạ mà mình mang theo\nĐã cuốn đi xa dần biết bao mơ mộng ngày ta có đôi\n\nNên khẽ đến nhẹ nhàng với một cô gái chưa bao giờ yêu\nLà lần đầu tiên em biết tim mình đã rung động\nThế cứ thế từng ngày anh vội vàng khuất xa nơi đại dương\nChẳng thế giữ tay anh lại\n\nEm đã yêu một người có ước mơ\nMơ điều làm em thấy hoang mang lo sợ\nSợ yêu một người không phải như em đã từng\nNếu như anh đi về phía đó liệu rằng anh có còn thấy em\nLệ trong đôi mắt sao mà lấp đi ánh nắng mặt trời\n\nVẫn yêu dù cho có cô đơn\nDù cho anh không của riêng em sau này\nMộng mơ mà anh ôm lấy sao chẳng có em\nNắng ban mai soi đường anh mãi là hoàng hôn tắt lụi với em\nPhải yêu anh cho đến bao giờ em được hạnh phúc riêng mình\n\nChẳng muốn sau này cứ mãi hy vọng chôn vùi tình em vào cơn bão tố\nĐau đến muôn phần anh có đâu hay mình em suy tư mỗi đêm\nLại nhớ thương người không chắc bên nhau một mai khi trời sáng lên\nĐể rồi ngày hôm nay là ngày mà anh rời xa em\n\nLỡ yêu một người có ước mơ\nMơ điều làm em thấy hoang mang lo sợ\nSợ yêu một người không phải như em đã từng\nNếu như anh đi về phía đó liệu rằng anh có còn thấy em\nVì lệ trong đôi mắt sao mà lấp đi ánh nắng mặt trời\n\nĐã yêu dù cho có cô đơn\nDù cho anh không của riêng em sau này\nMộng mơ mà anh ôm lấy sao chẳng có em\nNắng ban mai soi đường anh mãi là hoàng hôn tắt lụi với em\nNgàn cơn mưa xuống cho đêm thôi lạnh em thôi bật khóc\nPhải yêu anh cho đến bao giờ em được hạnh phúc riêng mình',
    album: 'Vọng',
  ),
  Song(
    id: 38,
    title: 'Thế còn anh thì sao',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/th____c__n_anh_th___sao.jpg',
    assetPath: 'assets/audio/th____c__n_anh_th___sao.mp3',
    lyrics: 'Tình yêu này khiến em đau đầu\nLuôn luôn đầy giông tố\nNgày qua ngày tháng em gieo sầu\nCho ta cách xa\nVì anh mà dấu yêu thay màu\nEm cho là như thế\nGiờ đây chẳng giống như ban đầu\nChỉ còn một mình anh\nVẫn đợi chờ\nDù bóng em dần phai\nBao nhiêu lần anh đã cố gắng\nMuốn nói anh vẫn luôn còn yêu em\nChưa khi nào anh thôi nhung nhớ\nNhưng chính em\nLuôn ôm chặt hờn ghen\nTừng lời nói cất lên lalalala\nMuộn phiền cứ chất thêm lalalala\nĐến bây giờ\nEm vẫn chẳng ngưng than vãn\nKhi nỗi đau em thật nhiều\nVậy thì này em ơi\nThế còn anh thì sao\nThế còn anh thì sao\nThế còn anh thì sao\nThế còn anh thì sao\nHàng trăm lời nhắn em không đọc\nEm đâu cần hay biết\nMàn đêm là thói quen nghi ngờ\nEm không muốn tin\nĐừng ai lại bắt em mong chờ\nKhi yêu là ngang trái\nTừng giây từng phút em ơ thờ\nChỉ còn một mình\nAnh vẫn lặng yên nhìn\nBóng em dần phai\nBao nhiêu lần anh đã cố gắng\nMuốn nói anh vẫn luôn còn yêu em\nChưa khi nào anh thôi nhung nhớ\nNhưng chính em\nLuôn ôm chặt hờn ghen\nTừng lời nói cất lên lalalala\nMuộn phiền cứ chất thêm lalalala\nĐến bây giờ\nEm vẫn chẳng ngưng than vãn\nKhi nỗi đau em thật nhiều\nVậy thì này em ơi\nThế còn anh thì sao\nThế còn anh thì sao\nThế còn anh thì sao\nThế còn anh thì sao\nTình yêu này khiến em đau đầu\nNgày qua ngày tháng em gieo sầu\nBình yên chẳng phải là thứ\nEm mong cầu\nNo no no no\nNo no no no\nTình yêu này khiến em đau đầu\nNgày qua ngày tháng em gieo sầu\nBình yên chẳng phải là thứ\nEm mong cầu\nNo no no no\nBao nhiêu lần anh đã cố gắng\nMuốn nói anh vẫn luôn còn yêu em\nChưa khi nào anh thôi nhung nhớ\nNhưng chính em\nLuôn ôm chặt hờn ghen\nTừng lời nói cất lên lalalala\nMuộn phiền cứ chất thêm lalalala\nĐến bây giờ\nEm vẫn chẳng ngưng than vãn\nKhi nỗi đau em thật nhiều\nVậy thì này em ơi\nThế còn anh thì sao\nThế còn anh thì sao\nThế còn anh thì sao\nThế còn anh thì sao\nChưa bao giờ em dành cho anh\nLời xin lỗi\nMỗi khi em làm sai\nNgười trả lời là câu\nThế còn anh thì sao\nThế còn anh thì sao\nSao lại hỏi như thế\nTình yêu này khiến em đau đầu\nNgày qua ngày tháng em gieo sầu\nBình yên chẳng phải là thứ\nEm mong cầu\nNo no no no\nNo no no no no\nTình yêu này khiến em đau đầu\nNgày qua ngày tháng em gieo sầu\nBình yên chẳng phải là thứ\nEm mong cầu\nNo no no no no\nNo no no no',
    album: 'Vọng',
  ),
  Song(
    id: 39,
    title: 'Tại vì em',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/t___i_v___em.jpg',
    assetPath: 'assets/audio/t___i_v___em.mp3',
    lyrics: 'Tại vì em\nLuôn mong muốn anh đi bên cạnh\nNhẹ hôn em bên dưới áng mây trôi\nTại vì em còn thương nhớ\nTừng ngày còn hoài mộng mơ\nTại vì em\nĐã lỡ yêu anh mà thôi\nTim em chứa chan\nLàm cho em đau rất nhiều\nĐậm sâu\nKhi mất đi chỉ càng thêm tiếc nuối\nCố gắng ngóng trông\nMặc đôi mi thêm rối bời\nEm chờ, chờ đợi cơn giông tới\nHãy để con sóng\nCuốn xô đi chuyện tình đôi ta\nTiếng yêu sâu đậm dần phôi pha\nVỡ tan theo từng đợt trôi xa\nVề nơi nắng lên\nLuyến lưu chi dòng lệ hoen mi\nTháng năm phai nhạt dần quên đi\nChẳng nhớ thương một người em từng yêu\nPhải làm sao\nCho cơn gió đêm đông thôi lạnh\nPhải làm sao cho em hết yêu anh\nTình yêu đem cơn mưa xuống\nĐổi cả ngàn lần lệ tuôn\nTại sao em\nCứ mãi thương anh mà thôi\nTim em chứa chan\nLàm cho em đau rất nhiều\nĐậm sâu\nKhi mất đi chỉ càng thêm tiếc nuối\nCố gắng ngóng trông\nMặc đôi mi thêm rối bời\nEm chờ, chờ đợi cơn giông tới\nHãy để con sóng\nCuốn xô đi chuyện tình đôi ta\nTiếng yêu sâu đậm dần phôi pha\nVỡ tan theo từng đợt trôi xa\nVề nơi nắng lên\nLuyến lưu chi dòng lệ hoen mi\nTháng năm phai nhạt dần quên đi\nChẳng còn một mình em hoài tiếc thương\nBầu trời kia đã khóc\nCho bao ngọt ngào em trao\nBiết em ôm khổ đau ra sao\nNhững đêm em thầm gọi tên anh\nHằng bao xót xa\nLuyến lưu chi dòng lệ hoen mi\nTháng năm phai nhạt dần quên đi\nChẳng nhớ thương một người em từng yêu\nVì quá yêu anh thôi\nTại vì em',
    album: 'Vọng',
  ),
  Song(
    id: 40,
    title: 'Chân đất',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/ch__n______t.jpg',
    assetPath: 'assets/audio/ch__n______t.mp3',
    lyrics: 'Chân đất đi trên bầu trời sáng trăng\nCó ai nghe tim tôi gọi thì hoà theo lấy một đôi nhịp\nNét bút trong veo đầu đời mới sa\nCó ai nghe chân tôi giậm trả lời đi đừng bắt tôi tìm\nBắc ghế ra ngồi vắt vẻo trước hiên nhà\nHát câu hát hôm qua\nThích nên vẫn ngân nga\nTập tành ném suy nghĩ ra xa\nBước đi chân thật vẫn cứ bước đi\nĐi tìm không gian mới về một hướng mây còn vương đầy\nNgày thơ ấu (ngày thơ ấu), khi tui còn bé\nCả thế giới của tui là những viên bi lấp lánh tròn xoe\nLà cái thời quần đùi thủng đít còn áo ba lỗ ôi chất ngất\nĐầu đội trời chân đạp đất mà cứ tưởng mình là nhất\nVà thuở ấy! “Chân đất” không nghĩ nhiều về [tương lai]\nCứ tự do ung dung tự tại vì đâu biết đúng hay là [sai]\nKhông quan tâm vấn đề ngày mai\nHay là tuần sau đến hạng đến hạn nộp bài\nVà có ai cho tui biết tuổi trẻ này quá ngắn\nPhải qua hết ngày mưa rồi mới có nắng\nCó nhiều đêm phải thức trắng, có nhiều đêm phải lo lắng\nCó lúc cũng khó khăn. Nhưng mà vẫn k quên lời thầy là phải có làm thì mới có ăn\nCó thể buồn nhưng k được nản\nMai thức dậy, mây vẫn trôi còn bầu trời vẫn còn sáng\nCó lúc chán, nhưng đôi chân k để bản thân mình được dừng lại\nVà mặc kệ là đi Chân Đất( yah) cứ đi mà k cần ngần ngạ\nBàn chân bàn chân nào không đi qua khó khăn\nVẫn bước tiếp dẫu đêm đen ngược lối, mặc cho lẻ loi dắt theo ta đi cùng\nLời ca lời ca nào chẳng hằn in tháng năm,\nDù biết có lẽ ánh trăng kia lừa dối, Kệ ! vụt qua màn sương khuất xa sau lưng đồi.\nTa đã từng ghét mặt trời vào mỗi sáng thứ hai\nghét những lời phán xét nên không dám thử lại\nta đã từng yêu hoàng hôn vào cái lúc ban chiều\nyêu cái lúc ngây thơ lúc chưa thấy khó khăn nhiều\ncuộc đời là bài văn mà ta không muốn đặt nỗi buồn ở trang chót\nluôn làm điều mình thích nhưng không kết thúc như Van Gogh\nvà muốn đưa nhau đi trốn đến một nơi thật xa\nngồi dưới hiên nhà mơ về những ngày khác lạ\nThời gian này không dành cho lời than\nChạy nhanh khi ngày mộng mơ vụt theo đường chân trời\nVẫn còn tiếp tục đi vì không\nMột ai đợi chờ ta đứng lại\nTa nhìn để thấy được dáng hình\nta nghe để thấu được thanh âm\nđứng lại để có thể bước tiếp\nbước đi để biết mình nhanh chậm\ndù chân đất nhưng tay cầm chặc cây bút này ta ghi\nnhớ lại một vài khoảnh khắc khi mà giây phút này qua đi\nLà thằng nhóc rất ít khi vâng lời\nChập chững những ước mơ xa vời\nBật khóc hết nỗi lo trong đời\nRồi thì vẫn cứ ngước lên mây trời\nHát những nghĩ suy vơi đầy\nMình khát hết nỗi đam mê này\nDù mai ta đi tới đâu mặc kệ rằng chân ta đi đất chân không mang giày',
    album: 'Vọng',
  ),
  Song(
    id: 41,
    title: 'Dù cho mai về sau',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/d___cho_mai_v____sau.jpg',
    assetPath: 'assets/audio/d___cho_mai_v____sau.mp3',
    lyrics: 'Bầu trời đêm không mây không sao, trăng treo trên cao khi lòng anh vẫn nhớ nhung em nhiều\nAnh làm sao có thể ngừng suy nghĩ đến đôi môi em, dù chỉ một giây\nMặc cho ta đi bên nhau bao lâu, em đâu hay anh cần bao câu nói anh yêu em\nChỉ để em sẽ một lần nhìn thấy trái tim anh đang rung động biết bao\n\nDù lời nói có là gió bay, anh vẫn mong sau này chúng ta trở thành của nhau\nMệt thì cứ ngoái lại phía sau, anh vẫn luôn đây mà\nDù thời gian không chịu đứng yên, để cho chính anh không còn ngẩn ngơ, cũng thôi mơ mộng\nThì anh vẫn luôn dành những câu ca trong lòng anh cho người mãi thôi\n\nDù cho mai về sau, mình không bên cạnh nhau, làm tim anh quặn đau, anh trông ngóng bao nhiêu lâu\nDù vương vấn u sầu, mùa thu có phai màu, anh vẫn muốn yêu em\nDù cho muôn trùng phương, còn bao nhiêu lời thương\nDù mênh mông đại dương, phai đi sắc hương mơ màng\nAnh vẫn yêu mình em thôi đấy, em ơi đừng để tình anh dở dang\n\nDù lời nói có là gió bay, anh vẫn mong sau này chúng ta trở thành của nhau\nMệt thì cứ ngoái lại phía sau, anh vẫn luôn đây mà\nDù thời gian không chịu đứng im để cho chính anh không còn ngẩn ngơ cũng thôi mơ mộng\nThì anh vẫn luôn dành những câu ca trong lòng anh cho người mãi thôi\n\nDù cho mai về sau, mình không bên cạnh nhau, làm tim anh quặn đau, anh trông ngóng bao nhiêu lâu\nDù vương vấn u sầu, mùa thu có phai màu, anh vẫn muốn yêu em\nDù cho muôn trùng phương, còn bao nhiêu lời thương\nDù mênh mông đại dương, phai đi sắc hương mơ màng\nAnh vẫn yêu mình em thôi đấy, em ơi đừng để tình anh dở dang\n\nDù lời nói có là gió bay, dù ngày tháng có còn đổi thay\nThì anh vẫn mãi muốn nắm đôi bàn tay, dắt theo những hy vọng đông đầy\n\nDù cho mai về sau, mình không bên cạnh nhau, làm tim anh quặn đau, anh trông ngóng bao nhiêu lâu\nDù vương vấn u sầu, mùa thu có phai màu, anh vẫn muốn yêu em\nDù cho muôn trùng phương, còn bao nhiêu lời thương\nDù mênh mông đại dương, phai đi sắc hương mơ màng\nAnh vẫn yêu mình em thôi đấy, em ơi đừng để tình anh dở dang\n\nDù cho muôn trùng phương, còn bao nhiêu lời thương\nDù mênh mông đại dương, phai đi sắc hương mơ màng\nAnh vẫn yêu mình em thôi đấy, yêu em mà chẳng một lời thở than',
  ),
  Song(
    id: 42,
    title: 'Đường tôi chở em về ',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/_______ng_t__i_ch____em_v____.jpg',
    assetPath: 'assets/audio/_______ng_t__i_ch____em_v____.mp3',
    lyrics: 'Xe đạp lách cách tôi vẫn chưa quen\nĐường thì tối chơi vơi còn tôi vẫn đứng đợi\nEm nhẹ bước đến mi đã thôi hoen\nTrời trở gió heo may vì tôi đã lỡ yêu em\nCũng may đường về nhà em quá xa\nTôi mới được trông ngóng em buông lời hát\nNhớ thương ngại ngùng nhìn em thoáng qua\nHạ ơi đứng trôi mãi, mặc kệ em với tôi đi về\nMới chỉ nhìn em khóc\nTôi bỗng chợt nhận ra đã yêu em rồi\nSáng trong cho mây ngừng trôi\nRọi ánh mắt em trong lòng tôi\nNgập ngừng chưa nói\nMai sau để cho anh ngóng em đi về\nKhoảnh khắc tôi chưa nên câu\nHàng mi ướt run run buông dài theo cơn gió\nVén nhẹ tà áo\nTrên con đường tôi đi với em\nDù phía trước có mưa rào\nTrên đường hai ta sẽ qua\nChỉ muốn em dành tặng cho tôi\nNhững ngây thơ đầu\nĐược dỗ dành em khi em buồn\nĐứng chờ em đưa em về từng ngày\nĐường này là đường cho tôi chở em mãi thôi không dừng\nĐường tôi đi cùng em mãi thôi không ngừng\nChợt hiện lên dòng suy nghĩ tôi chưa từng\nKể em nghe lời yêu biết đâu, thôi đừng\nĐợi chờ em như chờ ánh nắng lên\nChờ cho lại nghe tiếng con tim thổn thức\nNhẹ nhàng hương hoa gần đến sát bên\nNhẹ theo chiều phai gió dựa vai tôi mỗi khi về\nMới chỉ nhìn em khóc\nTôi bỗng chợt nhận ra đã yêu em rồi\nSáng trong cho mây ngừng trôi\nRọi ánh mắt em trong lòng tôi\nNgập ngừng chưa nói\nMai sau để cho anh ngóng em đi về\nKhoảnh khắc tôi chưa nên câu\nHoa cứ ngát hương em đêm hè dòng sông\nKhẽ vén nhẹ tà áo\nTrên con đường tôi đi với em\nDù phía trước có mưa rào\nTrên đường hai ta sẽ qua\nChỉ muốn em dành tặng cho tôi\nNhững ngây thơ đầu\nĐược dỗ dành em khi em buồn\nĐứng chờ em nơi em về\nSẽ chẳng cần lên tiếng\nTâm tư này để tôi cất riêng cho mình\nRồi vẫn đạp xe như bao ngày\nHạ vẫn dần trôi\nNhớ thương em\nTôi đưa em về\nBầu trời sao sáng lên\nRọi ánh mắt em trong lòng tôi\nNhớ thương em\nLỡ mai sau này\nMình chẳng thể mãi đón đưa\nLại cứ thế ngóng trông\nĐường này là đường cho tôi chở em mãi thôi không dừng\nĐường tôi đi cùng em mãi thôi không ngừng\nChợt hiện lên dòng suy nghĩ tôi chưa từng\nKể em nghe lời yêu biết đâu, thôi đừng\nĐường này là đường cho tôi chở em mãi thôi không dừng\nĐường tôi đi cùng em mãi thôi không ngừng\nChợt hiện lên dòng suy nghĩ tôi chưa từng\nKể em nghe lời yêu biết đâu, thôi đừng',
  ),
  Song(
    id: 43,
    title: 'Em không khóc',
    artist: 'Bùi Trường Linh',
    coverImage: 'assets/images/em_kh__ng_kh__c.jpg',
    assetPath: 'assets/audio/em_kh__ng_kh__c.mp3',
    lyrics: 'Cứ bước thẳng vào trong\nGiống hệt thói quen mà không cần nghĩ ngợi\nNhư thể ở đây chỉ có một mình chẳng ai để ý tới\nLần nào cũng cô đơn như vậy vẫn còn muốn đợi\nCó lẽ bây giờ điều cần thiết nhất là một giấc nghỉ ngơi\nCó người uống không bỏ sót chẳng để lại dư giọt nào\nNhìn bộ dạng thì thứ họ rót không thể là thứ ngọt ngào\nChâm đốm lửa\nMột vài âm thanh khiến tôi phải đoán xem\nTiếng giày cao gót vừa bước vào\nLà cô ca sĩ ở quán quen\nẤy không, đây không phải điều tôi hi vọng tối nay\nCó nhiều hơn một lý do khiến tôi phải ngồi trong xe để tới đây\nNhả khói bay\nBartender hiểu tôi cần một dư vị đậm chất\nĐôi lúc thứ sâu đậm nhất lại khiến mình chẳng thể nói ngay\nNgắm nghía xung quanh một vòng sau lần chợp mắt bị dập tắt\nKhông cách quá xa ánh đèn nơi tôi cho rằng phù hợp nhất\nMột ngụm quên hết màn đêm thì còn trái tim nào chưa muốn mở\nĐặt xuống, nhìn em qua ly Dry Gin còn đang uống dở\n_\nMột người xinh như em sao lại ở đây giờ này nhỉ\nVẫn không phải điều bình thường cho dù tôi biết rằng mai là ngày nghỉ\nMiniskirt và ở bên dưới là một đôi Blazer Low\nEm vén mái tóc mình lại, buộc gọn nó ở ngay đằng sau\nUhm đúng rồi\nTôi thích em trông mạnh mẽ thế này hơn\nKhi con người ta thường bị tổn thương bởi vài thứ giản đơn\nLà khi em không còn cảnh giác\nThái độ bất cần cũng đã mất dần\nLà trong một khoảnh khắc\nKhoảng cách của tôi và em đã rất gần\nEm thất thần, nhìn lại ngay cái Hublot bên tay trái\nTôi cá là em không đủ tỉnh táo để biết được giờ là nửa đêm\nSoạn sửa thêm, em thả xuống cái túi xách hồi nãy vắt ngược lên vai\nLỡ say đến thế, miệng vẫn còn lẩm bẩm nhắc được tên ai \nĐôi mắt màu nâu sậm, chứa nỗi buồn sâu đậm\nLỡ đánh rơi vài viên thuốc mấy người bình thường nào đâu ngậm\nSân khấu đang hát từng câu chậm theo nhịp bước chân tôi đi tới\nCuối cùng thì đã đến lúc lại bên em và ngỏ lời\n_\nLý do bất khả kháng, nhưng nghe qua lại rất thoả đáng\nTôi vừa làm được một chuyện mấy gã bàn bên chắc phải vất vả chán\nCó khi mất cả tháng, mà nào có dịp nói đâu hả trời\nNhận câu trả lời khiến giai điệu kia một lần nữa toả sáng\nKhi mà đôi bên đã trải qua được những phút đầu cầm cự\nTôi chắc chắn là người đáng tin để em trút bầu tâm sự\nChuyện gia đình và những áp lực chưa một lần than thở\nMối tình mà em dốc hết tâm can, lúc này chỉ còn dang dở\nĐưa vội hai tay, che đi nỗi uất ức nghẹn trào\nEm bảo không khóc nhưng lời em nói cứ bị tiếng nấc chẹn vào\nTừ khi nào quãng đường em đi phải bước những bước nghẹn ngào\nNhư thể tuổi xuân vốn trôi qua chưa từng có lời ước hẹn nào\nLy rượu giờ đối với em cứ như điều ước đặt ở trước mặt\nNuốt hết niềm cay đắng, nuốt nước mắt mà chẳng cần bước ngoặt\nNhững niềm đau mà không mũi khâu nào ai vá nổi\nEm dần học cách để cho làn khói đi sâu vào hai lá phổi\nNhưng em ơi, em xứng đáng nhiều hơn những điều như thế\nAnh chắc là sẽ luôn có một nơi đang đợi em trở về\nĐừng lựa chọn lấy điều tiêu cực là thứ em nghĩ tới\nBuồn đau chẳng giống men rượu, em càng uống càng không cách gì vơi\nCòn cả một chặng đường dài chờ em phía trước kìa\nVẫn hãy cứ là mình, vẫn vui vẻ hồn nhiên như trước kia\nLúc mặt trời lên, khi bồ công anh khẽ chớm nở dại \nÁnh nắng kề bên, nụ cười trên môi em sẽ sớm trở lại\nNhư nhận ra những lời tôi nói, em mỉm cười không còn đẫm lệ\nVài người khách cuối cùng, đưa nhau đi chẳng hề chậm trễ\nChấm hết cho một ngày dài, khi cả em và nó đều ngã gục\nChắc là viên thuốc vừa nãy đánh tráo đã có tác dụng\nBước thẳng vào trong, giống hệt thói quen không cần nghĩ ngợi\nNhư thể ở đây chỉ có một mình chẳng ai để ý tới\nLần nào cũng cô đơn như vậy mà vẫn còn muốn đợi\nCó lẽ bây giờ điều cần thiết nhất, là một giấc nghỉ ngơi.\n\n',
  ),
  Song(
    id: 44,
    title: 'Nói dối',
    artist: 'Ronboogz',
    coverImage: 'assets/images/n__i_d___i.jpg',
    assetPath: 'assets/audio/n__i_d___i.mp3',
    lyrics: 'Em nói em không hề mệt, công việc cứ thế càng nhiều thêm\nVà em nói nó rất là vui, cho dù em đã thức nhiều đêm\nEm nói em không hề buồn, khi anh ta nói lời tạm biệt\nEm cứ nghĩ anh ta đùa thôi, nhưng anh ta làm thiệt\nEm nói em chỉ cần miếng chăn\nBut i’m still ok em không cần người viếng thăm.\nEm nói em rất bình thường, không phải người tiếng tăm\nNên miệng đời chẳng thể làm mình nghiến răng, Nhưng\nĐk:\nEm không giỏi nói dối như em nghĩ đâu (X5)\nTuy anh không giỏi bắt sóng giống như radio\nNhưng khi em buồn phát khóc em nghĩ anh biết đâu\nKhi em hoà mình trong list Travis Scott\nVer2:\nĐôi môi em hay thường cười, còn tay trái em thường cầm lon\nAnh tự cho mình học trường đời nhưng tiếc cái là trường mầm non.\nNhưng anh biết đã bao nhiêu lần em luôn tìm cách bão hoà\nNhững đau đớn nó chia nhiều phần còn hơn cả sách giáo khoa\nEm nói không sợ đời giết em\nVà em không thấy chạnh lòng khi đêm bầu trời rét thêm\nEm không nhớ những đêm canh ba, em không nhớ chiếc hôn anh ta\nVà em không nhớ những lời đàn bà của bao nhiêu người ghét em\nEm nói không cần tình yêu vì toàn là giả dối\nEm nói không cần người bên em khi em già cỗi\nEm nói đã sai một lần và em không muốn sai thêm\nVà nếu có chiếu phim cuộc đời em cũng không muốn ai xem\nVậy sao em lại khóc? oh\nVậy sao em phải khóc? Oh\n\nĐk:\nEm không giỏi nói dối như em nghĩ đâu (X5)\nTuy anh không giỏi bắt sóng giống như radio\nNhưng khi em buồn phát khóc em nghĩ anh biết đâu\nKhi em hoà mình trong list Travis Scott\nCoda:\nSao phải khóc? Khi nắng đang dần phai\nSao phải khóc? Khi em nói em chẳng cần ai\nSao phải khóc? Khi có anh gần lại\nVà trong cuộc sống chuyện gì chẳng có lần hai\nEm nói không sợ đời giết em\nVà em không thấy chạnh lòng khi đêm bầu trời rét thêm\nEm không nhớ những đêm canh ba, em không nhớ chiếc hôn anh ta\nVà em không nhớ những lời đàn bà của bao nhiêu người ghét em',
  ),
  Song(
    id: 45,
    title: 'Hai đứa nhóc',
    artist: 'Ronboogz',
    coverImage: 'assets/images/hai______a_nh__c.jpg',
    assetPath: 'assets/audio/hai______a_nh__c.mp3',
    lyrics: 'Khi thơ bé lúc ánh trăng lên đầu làng\nCô ta đứng dưới gốc cây phong màu vàng\nAnh ta nói phía xa xa nơi tàu hàng\nNơi những ước mơ trong ta đang bầu bạn\nHai ta sống đôi khi cũng chẳng cần gì\nVì hai ta vốn không phải con người cầu toàn\nNên khi lớn ta không còn phải lầm lì\nVà hai đứa nhóc chưa bao giờ phải đầu hàng\n\nChỉ cần nhiêu đó thôi sau khi cơn gió trôi\nChớp mắt cũng đã ba năm rồi\nKhi đồng tiền ngỏ lời, giữa thành thị đông người\nKí ức cũng đã xa xăm rồi\nTrên tay bao hoá đơn sau bao năm khá hơn nhưng vẫn thiếu điều gì.\nCuộc sống vẫn thiếu nhiều vị\nVậy thì đừng quên mất nhau\nVì cuộc đời này thường làm như thế\nLời ngọt ngào này nên cất đâu\nKhi mình giờ chẳng còn là ngày thơ bé\nVậy thì đừng quên mất nhau\nVì cuộc đời mình đều sợ mất mát\nVào ngày mà mình được chôn rất sâu\nTa còn điều gì để lại ngoài đất cát\n\nCô ta lướt những ngón tay trên mặt đàn\nCô lấp lánh như bao nhiêu ánh đèn đường\nBao năm tháng chỉ có âm thanh làm bạn\nCho bao gã trai kia đi theo thèm thuồng\nAnh ta đứng lên nhanh trong bàn tiệc\nAnh ta nói không muốn ai làm phiền\nAnh ta ngó xa xa nơi đoàn thuyền\nKhi bóng tối giờ đây đang toàn quyền\n\nChỉ cần nhiêu đó thôi sau khi cơn gió trôi\nChớp mắt cũng đã ba năm rồi\nKhi đồng tiền ngỏ lời, giữa thành thị đông người\nKí ức cũng đã xa xăm rồi\nTrên tay bao hoá đơn sau bao năm khá hơn nhưng vẫn thiếu điều gì.\nCuộc sống vẫn thiếu nhiều vị\nVậy thì đừng quên mất nhau\nVì cuộc đời này thường làm như thế\nLời ngọt ngào này nên cất đâu\nKhi mình giờ chẳng còn là ngày thơ bé\nVậy thì đừng quên mất nhau\nVì cuộc đời mình đều sợ mất mát\nVào ngày mà mình được chôn rất sâu\nTa còn điều gì để lại ngoài đất cát\n\nNgày tháng vẫn thế qua mau,\nVẫn thế dừng lại ở nơi ta xa nhau\nNếu có gặp lại, thì xin em đứng yên\nXin em đừng ngại\nCố giữ lời hứa trên con đường dài\nVì ta luôn cô đơn, ta luôn buồn phiền\nVì ta thương nhau hơn, hơn cả đồng tiền\nHãy để đứa nhóc trong ta ở lại\nVì ta chưa lớn bao giờ.',
  ),
  Song(
    id: 46,
    title: 'Nhắn nhủ',
    artist: 'Ronboogz',
    coverImage: 'assets/images/nh___n_nh___.jpg',
    assetPath: 'assets/audio/nh___n_nh___.mp3',
    lyrics: 'Đêm nay\nAnh cố viết cho bài nhạc thêm hay\nKhi anh cố đưa mình vào men say\nMong bóng tối thu gọn ở trên tay\nĐêm dần trôi\nNhư cái cách bài nhạc này thêm từng lời\nNhư cái cách hai ta gặp nhau mà thôi\nNhư cái cách khi em rời xa đời tôi\nVà nếu sự thật là chẳng thể giữ sự thật thà và anh muốn đi tìm một nơi khác\nThì em hãy cho qua đi những đau đớn trong ta vì những kỉ niệm này thực sự hơi ác\nAnh chỉ muốn em vui\nMuốn em hạnh phúc bên ai\nMuốn em cười\nMuốn em đừng nghe tên anh đến tai\nAnh chỉ muốn em vui\nMuốn em thả trôi kí ức lên mây\nMuốn em cười\nGiống như ngày xưa khi em đến đây\nTình yêu chìm xuống bao lâu, để rồi ngoi lên trên mặt đất\nTừ ngày anh vội vã trao câu, để rồi đau khi em làm mất\nBao năm tháng bên nhau chỉ để chuyện ta càng lúc thêm sâu\nAnh chẳng thể nói nên câu nên để nhạc vang lên trong đêm thâu\nSự luyến tiếc vô tình kiến thiết thêm nhiều diễn biến cho mình yết kiến\nAnh làm biếng viết những điều luyên thuyên như chạm bên tim theo dạng tiếp tuyến\nAnh cần chuyên viên để có thể biết hết, cách để thoát khỏi đây\nNhững điều quyến luyến có thể giết chết, con người ta vậy đấy\nVà nếu sự thật là chẳng thể giữ sự thật thà và anh muốn đi tìm một nơi khác\nThì em hãy cho qua đi những đau đớn trong ta vì những kỉ niệm này thực sự hơi ác\nAnh chỉ muốn em vui\nMuốn em hạnh phúc bên ai\nMuốn em cười\nMuốn em đừng nghe tên anh đến tai\nAnh chỉ muốn em vui\nMuốn em thả trôi kí ức lên mây\nMuốn em cười\nGiống như ngày xưa khi em đến đây\nNếu lòng em đau đớn tựa như ai đó thường hay nói\nThì nên nhớ rằng một chiếc lá rụng là chiếc lá được thay mới\nVà hãy giữ những đớn đau lạc đàn\nKhi điếu thuốc sẽ chấm vào gạt tàn\nDấu vết lúc mới yêu bạt ngàn\nĐiều này quý giá đối với em hơn bạc vàng\nVà nếu một mai em có gặp ai mang đến được niềm vui\nThì nên nhớ niềm đau em giữ càng lâu sẽ giúp mình êm xuôi\nVì ta không quen đớn đau quá nhiều lần\nTa không nên đớn đau khi chiều tàn\nAnh chỉ muốn em vui\nMuốn em hạnh phúc bên ai\nMuốn em cười\nMuốn em đừng nghe tên anh đến tai\nAnh chỉ muốn em vui\nMuốn em thả trôi kí ức lên mây\nMuốn em cười\nGiống như ngày xưa khi em đến đây (oh)',
  ),  Song(
    id: 47,
    title: 'Nắng ấm xa dần',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/n___ng____m_xa_d___n.jpg',
    assetPath: 'assets/audio/n___ng____m_xa_d___n.mp3',
    lyrics: 'Nắng ấm xa dần rồi\nNắng ấm xa dần rồi\nNắng ấm xa dần bỏ rơi để lại những giấc mơ\nGiữ lại đi giữ giữ lại đi\nNắng ấm xa dần rồi\nNắng ấm xa dần rồi\nNắng ấm xa dần xa dần theo những tiếng cười\nHãy mang đi giúp những nỗi buồn\n\nTheo thời gian những hạt mưa như nặng thêm\nXóa hết thương yêu mặn nồng ngày nào giữa chúng ta\nAnh lục tìm vẫn cứ mãi lục tìm\nGiơ bàn tay cố kìm nén những cảm xúc\nVùi mình vào đêm đen anh chẳng tìm thấy lối ra oh oh\n\nSau lưng là tiếng nói yêu anh chẳng rời xa anh (uh uh)\nTrước mắt anh điều đấy nó dối trá tại sao người vội quên mau (là vì em)\nBài ca anh viết sẽ không được trọn vẹn đâu em (vội bước đi)\nEm yêu một ai thật rồi mãi chẳng là anh đâu\n\nVậy thì người cứ bước đi xa nơi này\nÁnh bình minh sẽ không còn nơi đây\nBước đi xa nơi này\nNhững lời yêu sẽ không còn nơi đây\nPhải tự đứng lên mà thôi\nChe nhẹ đi những niềm đau và nỗi buồn\nXung quanh anh giờ đây cô đơn mình anh ôm giấc mơ (vì ai)\n\nNhìn em bước ra đi xa dần (hoh)\nNhìn em bước ra đi xa dần (hoh)\nNhìn em bước ra đi xa dần (hoh)\nNhìn em bước ra đi xa dần (hoh)\nM T P\n\nĐến rồi lại đi và cứ vội vàng đi\nTrao cho anh bao yêu thương rồi em lại bỏ đi\nGieo cho anh bao nhiêu niềm đau rồi em mau rời bỏ anh xa anh\nQuay mặt lặng lẽ quên mau\n\nUh em yêu quên thật rồi\nUh chẳng một lời chia ly\nQuên rồi em yêu quên rồi quên rồi\n\nVậy thì người cứ bước đi xa nơi này\nÁnh bình minh sẽ không còn nơi đây\nBước đi xa nơi này\nNhững lời yêu sẽ không còn nơi đây\nPhải tự đứng lên mà thôi\nChe nhẹ đi những niềm đau và nỗi buồn\nXung quanh anh giờ đây cô đơn mình anh ôm giấc mơ (là vì ai)\n\nVậy thì người cứ bước đi xa nơi này\nÁnh bình minh sẽ không còn nơi đây\nBước đi xa nơi này\nNhững lời yêu sẽ không còn nơi đây\nPhải tự đứng lên mà thôi\nChe nhẹ đi những niềm đau và nỗi buồn\nXung quanh anh giờ đây cô đơn mình anh ôm giấc mơ\n\nNhìn em bước ra đi xa dần (eh)\nNhìn em bước ra đi xa dần (eh)\nNhìn em nhìn em bước đi huh (eh)\nNhìn em bước ra đi xa (eh)\n\nNắng ấm xa dần rồi\nNắng ấm xa dần rồi\nNắng ấm xa dần bỏ rơi để lại những giấc mơ\nGiữ lại đi giữ giữ lại đi\nNắng ấm xa dần rồi\nNắng ấm xa dần rồi\nNắng ấm xa dần xa dần theo những tiếng cười\nHãy mang đi giúp những nỗi buồn',
    album: 'Sơn Tùng MTP',
  ),  Song(
    id: 48,
    title: 'Em của ngày hôm qua',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/em_c___a_ng__y_h__m_qua.jpg',
    assetPath: 'assets/audio/em_c___a_ng__y_h__m_qua.mp3',
    lyrics: 'Eh eh eh…\nEm đang nơi nào…\nCan you feel me.\nCan you feel me.\nEh eh eh\nM-tp\n\nLiệu rằng chia tay trong em có quên được câu ca.\nTình yêu khi xưa em trao cho anh đâu nào phôi pha.\nĐừng lừa dối con tim anh,em sẽ không buông tay anh được đâu mà.(Em không thể bước đi)\nGạt nước mắt yếu đuối đó cứ quay lại nơi anh.\nEm biết rằng cơn mưa qua đâu có che lấp được nụ cười đau thương kia.\nNước mắt đó vẫn rơi vì em..Oh baby..No baby..\n\nĐừng nhìn anh nữa,đôi mắt ngày xưa giờ ở đâu???\nEm còn là em?\nEm đã khác rồi.\nEm muốn quay lưng quên hết đi(Thật vậy sao?)\nTình yêu trong em giờ toàn giả dối.\nAnh không muốn vùi mình trong mơ.\nAnh không muốn đi tìm giấc mơ ngày hôm nao.\n\nĐừng vội vàng em hãy là em của ngày hôm qua.\nUhhhhhhh..\nXin hãy là em của ngày hôm qua.\nUhhhhhhh..\nĐừng bỏ mặc anh một mình nơi đây.\nUhhhhhhh..\nDừng lại và xoá nhẹ đi kí ức.\nUhhhhhhh..\nChìm đắm vào những lời ca dịu êm thưở nào.\n\nMưa đang rơi.\nĐôi tay buông lơi.\nMình anh ngồi đây tìm lại những khoảng không dường như chơi vơi.\nThật ngu ngốc.\nVu vơ.\nLang thang trên con đường tìm lại giấc mơ.\nDường như đã quá xa.\nVà em không còn thiết tha.\nNắm lấy đôi tay anh muốn giữ em ở lại.\nNếu cứ tiếp tục cả hai sẽ phải khổ đau.\nĐừng cố tỏ ra mạnh mẽ.\nĐó đâu phải là em.\nVậy đi… TẠM BIỆT EM ..!\n\nNhắm mắt lại hãy nghĩ đi.\nLâu nay em sống cho mình em mà.\nPhải không em hỡi người…???\nTìm lại thời gian của riêng đôi ta.\nNhưng sao trong anh đã quá tuyệt vọng.\nSự thật đang bủa vây nơi anh.\nForget baby…!!!!!\n\nĐừng nhìn anh nữa,đôi mắt ngày xưa giờ ở đâu???\nEm còn là em?\nEm đã khác rồi.\nEm muốn quay lưng quên hết đi.\nTình yêu trong em giờ toàn giả dối.\nAnh không muốn vùi mình trong mơ.\nAnh không muốn đi tìm giấc mơ ngày hôm nao.\n\nĐừng vội vàng em hãy là em của ngày hôm qua.\nUhhhhhhh..\nXin hãy là em của ngày hôm qua.\nUhhhhhhh..\nĐừng bỏ mặc anh một mình nơi đây.\nUhhhhhhh..\nDừng lại và xoá nhẹ đi kí ức.\nUhhhhhhh..\n\nEm mang những cảm xúc theo người mất rồi …!\n\nEm mang tiếng cười.\nEm mang hạnh phúc đi rời xa.\nXung quanh chỉ còn mỗi anh và những nỗi đau.\nHãy xoá sạch hết đi…Đừng vấn vương..\nVì em.\nDo em.\nChính em.\nHãy mang hết đi……\n\nNgười cứ vội vàng.\nNgười cứ vội vàng.\nXin hãy là em của ngày hôm qua.\nNgười bước xa rồi.\nVà người đã bước xa rồi.\n\nĐừng vội vàng em hãy là em của ngày hôm qua.\nUhhhhhhh..\nXin hãy là em của ngày hôm qua.\nUhhhhhhh..\nĐừng bỏ mặc anh một mình nơi đây.\nUhhhhhhh..\nDừng lại và xoá nhẹ đi kí ức.\nUhhhhhhh..\n\nĐừng vội vàng em hãy là em của ngày hôm qua.\nEm đã quên chưa?\nXin hãy là em của ngày hôm qua.\nAnh nghĩ những dòng cảm xúc trong em giờ đã hết thật rồi đấy!!\nĐừng bỏ mặc anh một mình nơi đây.\nChẳng còn gì cả.\nDừng lại và xoá nhẹ đi kí ức.\nEm hãy là em của ngày hôm qua đi … Xin em đấy ..!',
    album: 'Sơn Tùng MTP',
  ),  Song(
    id: 49,
    title: 'Chắc ai đó sẽ về ',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/ch___c_ai______s____v____.jpg',
    assetPath: 'assets/audio/ch___c_ai______s____v____.mp3',
    lyrics: 'Anh tìm nỗi nhớ\nAnh tìm quá khứ\nNhớ lắm kí ức anh và em\nTrả lại anh yêu thương ấy\nXin người hãy về nơi đây\nBàn tay yếu ớt cố níu em ở lại\nNhững giọt nước mắt\nLăn dài trên mi\nCứ thế anh biết phải làm sao\nTình yêu trong em đã mất\nPhai dần đi theo gió bay\nCòn lại chi nơi đây cô đơn riêng anh\nEm đi xa quá\nEm đi xa anh quá\nCó biết không nơi đây anh vẫn đứng đợi một giấc mơ\nAnh chờ đợi một cơn mưa\nSẽ xóa sạch giọt nước mắt\nNgồi trong đêm bơ vơ anh thấy đau em có biết không\nEm ơi anh nhớ\nEm ơi anh rất nhớ\nTừng câu nói ánh mắt của em giờ này ở nơi đâu\nChắc ai đó sẽ sớm quay lại thôi\nChắc ai đó sẽ sớm quay về thôi\nCầm bông hoa trên tay nước mắt rơi\nAnh nhớ em\nNhững giọt nước mắt\nLăn dài trên mi\nCứ thế anh biết phải làm sao\nTình yêu trong em đã mất\nPhai dần đi theo gió bay\nCòn lại chi nơi đây cô đơn riêng anh\nEm đi xa quá\nEm đi xa anh quá\nCó biết không nơi đây anh vẫn đứng đợi một giấc mơ\nAnh chờ đợi một cơn mưa\nSẽ xóa sạch giọt nước mắt\nNgồi trong đêm bơ vơ anh thấy đau em có biết không?\nEm ơi anh nhớ\nEm ơi anh rất nhớ\nTừng câu nói ánh mắt của em giờ này ở nơi đâu\nChắc ai đó sẽ sớm quay lại thôi\nChắc ai đó sẽ sớm quay về thôi\nCầm bông hoa trên tay nước mắt rơi\nAnh nhớ em\nAnh sẽ mãi nhớ thật nhiều những thứ thuộc về em\nTrong tim này vẫn mãi yêu người riêng em\nOhh-h-h\nEm đi xa quá\nEm đi xa anh quá\nCó biết không nơi đây anh vẫn đứng đợi một giấc mơ\nAnh chờ đợi một cơn mưa\nSẽ xóa sạch giọt nước mắt\nNgồi trong đêm bơ vơ anh thấy đau em có biết không?\nEm ơi anh nhớ\nEm ơi anh rất nhớ\nTừng câu nói ánh mắt của em giờ này ở nơi đâu?\nChắc ai đó sẽ sớm quay lại thôi\nChắc ai đó sẽ sớm quay về thôi\nCầm bông hoa trên tay nước mắt rơi\nAnh nhớ em\n\n',
    album: 'Sơn Tùng MTP',
  ),  Song(
    id: 50,
    title: 'Khuôn mặt đáng thương',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/khu__n_m___t_____ng_th____ng.jpg',
    assetPath: 'assets/audio/khu__n_m___t_____ng_th____ng.mp3',
    lyrics: 'Đôi môi này đi về ai (yeah)\nOk đêm nay sẽ là một đêm thật tuyệt (no no)\nYes Sir (ah hah Sơn Tùng MT)\nCơn mơ màng mùi hương theo làn gió cuốn em đi\nKề bên vai ai từng đêm (eh)\nNhẹ nhàng giờ này anh (eh mai sau)\nMang em về liệu rằng em còn nhớ tiếng yêu không\nỞ đây ngay phía sau em này (eh)\nLại một mình anh thôi níu giữ lại những âm thầm và nhớ\nĐừng khiến đôi môi dịu êm phải chịu ngàn giọt nước mắt đắng cay\nHạt mưa rơi tình chơi vơi giấc mơ này biết đi về đâu oh\nBài hát khi xưa anh viết bây giờ phải đặt dấu chấm hết thôi\n(Ở cuối con đường) anh xin một điều ước\nCho em bình yên vững bước chân cánh hoa úa tàn bước chân khép màn\nBóng ai xa ngút ngàn nước mắt rơi ướt tràn\nSầu làn mi khép tình buồn nay em\nBiết đi về chốn đâu khuôn mặt đáng thương\nTấm thân héo mòn nỗi đau có còn\nĐắng cay em đã chọn chính em đã chọn\nRời làn hơi ấm tình này không thấm\nBiết ai còn nhớ ai khuôn mặt đáng thương\nCánh hoa úa tàn em giờ không phải em mà anh thì không phải em mà\nKhuôn mặt em yêu vẫn thế nhưng nay cảm xúc đã quá nhạt phai mà\nNơi đâu cho anh cảm xúc thăng hoa nơi đâu anh nhìn khoảng cách đôi ta\nKhông gian đâu không chắc cho em nhìn ra một con người đến từ hôm qua\nEm giờ đang ở nơi nào cơn gió mang em đi đến nơi nào (hu hu)\nBên cạnh ai kia ở nơi nào đôi chân em lang thang đến nơi nào\nNói cho anh nghe nói cho anh nghe\nBước đi vội vàng em đang đi bên ai đó\nĐừng khiến đôi môi dịu êm phải chịu ngàn giọt nước mắt đắng cay\nHạt mưa rơi tình chơi vơi giấc mơ này biết đi về đâu oh\nBài hát khi xưa anh viết bây giờ phải đặt dấu chấm hết thôi\n(Để cuối con đường) anh xin một điều ước\nCho em bình yên vững bước chân\nCánh hoa úa tàn bước chân khép màn\nBóng ai xa ngút ngàn nước mắt rơi ướt tràn\nSầu làn mi khép tình buồn nay em\nBiết đi về chốn đâu khuôn mặt đáng thương\nTấm thân héo mòn nỗi đau có còn\nĐắng cay em đã chọn chính em đã chọn\nRời làn hơi ấm tình này không thấm\nBiết ai còn nhớ ai khuôn mặt đáng thương\nCánh hoa úa tàn\nCánh hoa úa tàn\nCánh hoa úa tàn\nCánh hoa úa tàn\nYeah a la la la (ouh)\nLa la la la (ouh)\nLa la la la (yeah)\nNgày đó ánh mắt ấy sẽ mãi mãi không bên em nữa đâu\nLàn gió ánh mắt ấy sẽ mãi mãi không bên em gửi trao\nLời nói ấm áp ấy sẽ mãi mãi không bên em nữa đâu\nỞ đó chắc có nhớ có khóc vấn vương vì ai nơi nào\nNgày đó ánh mắt ấy sẽ mãi mãi không bên em nữa đâu\nLàn gió ánh mắt ấy sẽ mãi mãi không bên em gửi trao\nLời nói ấm áp ấy sẽ mãi mãi không bên em nữa đâu\nỞ đó chắc có nhớ có khóc vấn vương vì ai nơi nào\nCánh hoa úa tàn\nKhuôn mặt đáng thương\nOh yeah yeah',
    album: 'Sơn Tùng MTP',
  ),  Song(
    id: 51,
    title: 'Không phải dạng vừa đâu',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/kh__ng_ph___i_d___ng_v___a_____u.jpg',
    assetPath: 'assets/audio/kh__ng_ph___i_d___ng_v___a_____u.mp3',
    lyrics: 'Oh oh (yeah)\nOh oh (Sơn Tùng M-TP)\nOh oh\nAh ah ah ah (hello em)\nỞ sau bờ vai là những sầu lo (ai cho tôi vậy)\nHình như đuổi theo là những nỗi lo\nVô tư đi cứ bám vào anh này\nSuy tư anh u não cả tháng ngày\nKhông may cho em yêu tìm đến phải đúng thằng điên rồ trên khinh khí cầu (ya)\nTôi là ai mà ai là tôi (mặc kệ cứ bay nào)\nTôi vì ai và ai vì tôi (cuộc sống dâng trào)\nĐừng có ngồi đó nhìn ngó gạt đi sự e dè dang vòng tay cùng tôi và hát\nNgân nga câu hát\nKhông phải dạng vừa đâu (hey)\nVừa vừa vừa vừa vừa đâu\nTôi không phải dạng vừa đâu\nVừa vừa vừa vừa đâu oh\nKhông phải dạng vừa đâu (hey)\nVừa vừa vừa vừa vừa đâu\nTôi không phải dạng vừa đâu\nVừa vừa vừa vừa đâu oh\nOne bắt đầu sự hình thành của ladykiller (eh eh)\nTwo bắt đầu sự hình thành của youngpilots\nThree sự kết hợp độc đáo đã tạo nên cái tên\nTên M -TP M M M -TP\nNgười ta soi mói bạn đến từng phút từng giây\nXung quanh bốn phương ôi sao mỗi tôi khác biệt\nỜ thì tôi đang sống cuộc sống của tôi mà thôi\nChẳng làm khó ai hay làm mất thời gian ai\nCòn ngại chi nữa lại đây cùng tôi và bay\nÂm thanh chốn đây kéo tôi bước đi mỗi ngày\nNgày trôi nhanh lắm chẳng mong chờ ai đợi ai\nGửi vào gió mây kèm theo ước mơ oh (không phải dạng vừa đâu)\nCuối con đường kia thênh thang muôn lối (vừa vừa vừa vừa vừa đâu)\nCuối chân trời kia không xa tôi tới (ừ thì)\nCó cơn mưa hoà tan nỗi niềm thế gian (và rồi)\nCó ai đang cùng tôi sống trọn từng phút giây\nCuối con đường kia thênh thang muôn lối\nCuối chân trời kia không xa tôi tới (ừ thì)\nCó cơn mưa hoà tan nỗi niềm thế gian (và rồi)\nCó ai đang cùng tôi sống trọn từng phút giây (ya ya)\nSinh ở trên đời\nTôi đi ngàn phương trời\nLang thang vi vu cùng mây cùng sao hoà theo nhiều câu ca tuyệt vời\nRong chơi tôi quên tháng ngày chuỗi ngày\nTôi tìm lấy bản thân này\nCho tôi yên bình cho thân mình\nKhông còn những khoảng cách lặng vô hình\nĐừng nhìn lại nhé\nĐể lại muộn phiền ở lại nhé\nTạm biệt chuyện đời ở lại nhé\nChỉ còn lại một nụ cười nhé\nTương lai ca vang mang đi ngày mai\nTa mang đi ngày mai\nNhỡ đâu không gian mênh mông bao la tương lai là ở ngày mai\nNhìn cuộc đời nhẹ tênh\nỪ mình sống sao cho nụ cười vẫn còn mãi\nVứt hết đi buồn bực ngoài kia (kia)\nBay lên cùng những vần thơ\nTa quên đi sự đời\nCùng một khát khao oh\nCùng một ước mơ oh\nĐằng sau bờ vai còn lại một lời nói\nNào ta cùng bước\nTừng lời ca cuốn âm thanh\nTừng cơn gió mong manh\nĐưa trái tim tôi hát ca vang từng ngày\nBình minh đón tương lai\nHoàng hôn khép chông gai\nMột nụ cười mới quanh giấc mơ\nỞ phía cuối đoạn đường\nMột ai đó đêm nay\nDang cánh tay ôm lấy thân tôi vào lòng\nMột điều tôi kiếm tìm một loài hoa khác biệt\nMùi hương chẳng giống theo một ai\nTôi là tôi ai là ai tôi mặc kệ thôi\nCuối con đường kia thênh thang muôn lối\nCuối chân trời kia không xa tôi tới (ừ thì)\nCó cơn mưa hoà tan nỗi niềm thế gian (và rồi)\nCó ai đang cùng tôi sống trọn từng phút giây\nCuối con đường kia thênh thang muôn lối\nCuối chân trời kia không xa tôi tới (ừ thì)\nCó cơn mưa hoà tan nỗi niềm thế gian (và rồi)\nCó ai đang cùng tôi sống trọn từng phút giây\nKhông phải dạng vừa đâu\nVừa vừa vừa vừa vừa đâu\nTôi không phải dạng vừa đâu\nVừa vừa vừa vừa đâu oh\nKhông phải dạng vừa đâu\nVừa vừa vừa vừa vừa đâu\nTôi không phải dạng vừa đâu\nVừa vừa vừa vừa đâu oh\nOh vừa đâu (chuchu)\nVừa đâu (ah ah)\nTôi không phải dạng vừa đâu (chuchu)\nVừa vừa vừa đâu (chuchu)\nKhông phải dạng vừa đâu (chuchu)\nVừa vừa đâu eh eh\nKhông phải dạng vừa đâu yeh\nVừa vừa vừa đâu (hoà quện cùng nhạc)\nKhông phải dạng ah yeah',
    album: 'Sơn Tùng MTP',
  ),
Song(
    id: 52,
    title: 'Thái Bình mồ hôi rơi',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/th__i_b__nh_m____h__i_r__i.jpg',
    assetPath: 'assets/audio/th__i_b__nh_m____h__i_r__i.mp3',
    lyrics: 'Bờ vai ai mang vác tấm hàng?\nMồ hôi tuôn rơi những tháng năm hao gầy\nVì tình yêu thương con, cha đánh đổi\nChạy buôn thâu đêm đi tuyến Sơn La, Thái Bình\nCó những ngày mùa đông lạnh thấu nhưng cha vẫn chưa về\nMẹ cười nhưng con biết mẹ lo lắm, cha ơi\nXuân chỉ về khi con nghe thấy tiếng xe quen thuộc\nTuổi thơ ơi, nhớ lắm bánh cáy theo tôi lớn khôn (theo tôi lớn khôn, theo tôi lớn khôn)\nThời gian trôi, con lớn dần\nCon biết ước mơ của con là gì\nChạy theo đam mê, con sợ con quên đi quê hương\nQuên mất một điều tuyệt vời\nMãi là người con Thái Bình, là con của mẹ\nNhớ đường xưa, dòng sông uốn quanh mộng mơ\nĐùa vui dưới mưa tình yêu, nơi thắm lên con tim này, oh-ooh-ooh-ooh-ooh\nNhớ lời ru nuôi con lớn lên, bài ca gửi vào trong gió êm đềm\nXin mây đưa đi về phương xa\nOh-oh-oh-ah-whoo\nOh-oh-oh-ah-whoo\nOh-oh-oh-ah-whoo\nOh-ah-ah-ah-ah-ah, oh-oh-oh\nAh-ah-ah\nAh-ah-ah\nCó những ngày mùa đông lạnh thấu nhưng cha vẫn chưa về\nMẹ cười nhưng con biết mẹ lo lắm, cha ơi\nXuân chỉ về khi con nghe thấy tiếng xe quen thuộc\nTuổi thơ ơi, nhớ lắm bánh cáy theo tôi lớn khôn, hmm-mm\nAh-ah-ah-ah-huh\nThời gian trôi (ah-ah-ah-ah-huh), con lớn dần (ah-ah-ah-ah-huh)\nCon biết ước mơ của con là gì\nChạy theo đam mê (ah-ah-ah-ah-huh), con sợ con quên đi quê hương (ah-ah-ah-ah-huh)\nQuên mất một điều tuyệt vời (ah-ah-ah-ah-huh)\nCon mãi là người con Thái Bình, là con của mẹ\nNhớ đường xưa, dòng sông uốn quanh mộng mơ\nĐùa vui dưới mưa tình yêu, nơi thắm lên con tim này, yeah-ooh-ooh-ooh-ooh\nNhớ lời ru nuôi con lớn lên, bài ca gửi vào trong gió êm đềm\nXin mây hãy về phương xa\nAh-ah\nAh-ah\nAh-ah\nAh-ah-ah-ah-ah-ah\nAh-ah (oh-oh-oh-oh-ooh)\nAh-ah (oh-oh-oh-oh-ooh)\nAh-ah (oh-oh-oh-oh-ooh)\nXin mây đừng đi về phương xa (ah-ah-ah-ah-ah-ah)\nAh-ah, yeah',
    album: 'Sơn Tùng MTP',
  ),  
  Song(
    id: 53,
    title: 'Âm thầm bên em',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/__m_th___m_b__n_em.jpg',
    assetPath: 'assets/audio/__m_th___m_b__n_em.mp3',
    lyrics: 'Khi bên anh em thấy điều chi?\nKhi bên anh em thấy điều gì?\nNước mắt rơi gần kề làn mi\nChẳng còn những giây phút\nChẳng còn những ân tình\nGió mang em rời xa nơi đây\nKhi xa anh em nhớ về ai?\nKhi xa anh em nhớ một người\nChắc không phải một người như anh\nNgười từng làm em khóc\nNgười từng khiến em buồn\nBuông bàn tay, rời xa lặng thinh bước đi\n\nHạt mưa rơi bủa vây trái tim hiu quạnh\nNgàn yêu thương vụt tan bỗng xa\nNgười từng nói ở bên cạnh anh mỗi khi anh buồn\nCớ sao giờ lời nói kia như gió bay\nĐừng bỏ rơi bàn tay ấy bơ vơ mà\nMột mình anh lặng im chốn đây\nYêu em âm thầm bên em\n\nYêu thương không còn nơi đây\nAnh mang tình buồn theo mây\nCơn mơ về mong manh câu thề\nTan trôi qua mau quên đi phút giây\n\nMưa rơi trên đôi mi qua lối vắng\nÁnh sáng mờ buông lơi làn khói trắng\nBóng dáng em, nụ cười ngày hôm qua, kí ức có ngủ quên chìm trong màn sương đắng? (Anh làm em khóc)\nAnh nhớ giọt nước mắt sâu lắng (anh khiến em buồn)\nAnh nhớ nỗi buồn của em ngày không nắng\nBuông bàn tay, rời xa lặng thinh bước đi\n\nHạt mưa rơi bủa vây trái tim hiu quạnh\nNgàn yêu thương vụt tan bỗng xa\nNgười từng nói ở bên cạnh anh mỗi khi anh buồn\nCớ sao giờ lời nói kia như gió bay?\n\nBàn tay bơ vơ mà\nCầm bông hoa chờ mong nhớ thương\nLàm sao quên người ơi, tình anh mãi như hôm nào\nVẫn yêu người và vẫn mong em về đây\nGiọt nước mắt tại sao cứ lăn rơi hoài?\nỞ bên anh chỉ có đớn đau\nThì anh xin nhận hết ngàn đau đớn để thấy em cười\nDẫu biết giờ người đến không như giấc mơ\nYêu em âm thầm bên em\nYêu em âm thầm bên em\nThì anh xin nhận hết ngàn đau đớn để thấy em cười\nDẫu biết giờ người đến không như giấc mơ\nYêu em âm thầm bên em',
    album: 'Sơn Tùng MTP',
  ),  Song(
    id: 54,
    title: 'Anh sai rồi ',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/anh_sai_r___i_.jpg',
    assetPath: 'assets/audio/anh_sai_r___i_.mp3',
    lyrics: 'Nếu ngày mai em rời xa anh\nAnh không biết sống thế nào đây\nCon tim anh nhói đau từng cơn\nAnh biết hạt mưa không ngừng rơi khi thấy em buồn\nXin thời gian hãy trở lại đi\nAnh không muốn mất em người ơi\nCon tim anh nhói đau từng cơn\nAnh khóc vì anh biết mình sai\nTất cả là vì tại anh\nAnh sai rồi\nAnh sai rồi\nXin em một lần hãy nói, "Em yêu anh"\nAnh xin nhận, nhận hết nỗi buồn\nĐừng rời xa kỉ niệm\nAnh vẫn ở đây ngóng chờ em\nGiờ em ở đâu?\nTìm em ở đâu?\nSao em nỡ bước đi rời xa?\nHãy quay trở về bên anh\nMột lần thôi em, anh đã sai rồi\nAnh như gục ngã, chìm đắm trong ly rượu say\nXin em một lần tha thứ, quay về bên anh\nAnh sai rồi (sai, sai, sai)\nAnh sai rồi (sai, sai, sai)\nXin em một lần hãy nói, "Em yêu anh"\nAnh xin nhận, nhận hết nỗi buồn\nĐừng rời xa kỉ niệm\nAnh vẫn ở đây ngóng chờ em\nGiờ em ở đâu?\nTìm em ở đâu?\nSao em nỡ bước đi rời xa?\nHãy quay trở về bên anh\nMột lần thôi em, anh đã sai rồi\nAnh như gục ngã, chìm đắm trong ly rượu say\nXin em một lần tha thứ, quay về bên anh\nAnh như gục ngã, chìm đắm trong ly rượu say\nXin em một lần tha thứ, quay về bên anh',
    album: 'Sơn Tùng MTP',
  ),  Song(
    id: 55,
    title: 'Chúng ta không thuộc về nhau',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/ch__ng_ta_kh__ng_thu___c_v____nhau.jpeg',
    assetPath: 'assets/audio/ch__ng_ta_kh__ng_thu___c_v____nhau.mp3',
    lyrics: 'Chúng ta không thuộc về nhau Chúng ta không thuộc về nơi này \nChúng ta không thuộc về nhau \nChúng ta không thuộc về nơi này\nNiềm tin đã mất \nGiọt nước mắt cuốn kí ức anh chìm sâu\nTình về nơi đâu \nCô đơn đôi chân lạc trôi giữa bầu trời \nMàn đêm che dấu\nTừng góc khuất lấp phía sau bờ môi\nTại vì anh thôi \nYêu say mê nên đôi khi quá dại khờ \nNhắm mắt ơ thờ \nAnh không muốn lạc vào trong nỗi đau này \nPhía trước bây giờ\nAi đang nắm chặt bàn của em vậy \nMông lung như một trò đùa \nAnh xin giơ tay rút lui thôi\nDo ai\nTrách ai bây giờ đây\nhúuuuuuuu\nChúng ta không thuộc về nhau \nChúng ta không thuộc về nhau\nChúng ta không thuộc về nhau \nEm hãy cứ đi bên người mà em cần \nTrái tim không thuộc về nhau \nGiấc mơ không là của nhau \nXóa câu ca buồn chiều mưa \nAnh lỡ xóa luôn yêu thương ngày xưa rồi \nChúng ta không thuộc về nhau ',
    album: 'Sơn Tùng MTP',
  ),
Song(
    id: 56,
    title: 'Nơi này có anh',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/n__i_n__y_c___anh.jpg',
    assetPath: 'assets/audio/n__i_n__y_c___anh.mp3',
    lyrics: 'Em là ai từ đâu bước đến nơi đây dịu dàng chân phương\nEm là ai tựa như ánh nắng ban mai ngọt ngào trong sương\nNgắm em thật lâu\nCon tim anh yếu mềm\nĐắm say từ phút đó\nTừng giây trôi yêu thêm\nBao ngày qua bình minh đánh thức xua tan bộn bề nơi anh (bộn về nơi anh)\nBao ngày qua niềm thương nỗi nhớ bay theo bầu trời trong xanh (bầu trời trong xanh)\nLiếc đôi hàng mi (hàng mi)\nMong manh anh thẫn thờ (thẫn thờ)\nMuốn hôn nhẹ mái tóc\nBờ môi em anh mơ\nCầm tay anh dựa vai anh\nKề bên anh nơi này có anh\nGió mang câu tình ca\nNgàn ánh sao vụt qua nhẹ ôm lấy em (yêu em thương em con tim anh chân thành)\nCầm tay anh dựa vai anh\nKề bên anh nơi này có anh\nKhép đôi mi thật lâu\nNguyện mãi bên cạnh nhau yêu say đắm như ngày đầu\nMùa xuân đến bình yên\nCho anh những giấc mơ\nHạ lưu giữ ngày mưa\nNgọt ngào nên thơ\nMùa thu lá vàng rơi\nĐông sang anh nhớ em\nTình yêu bé nhỏ xin\nDành tặng riêng em\nCòn đó tiếng nói ấy bên tai vấn vương bao ngày qua\nÁnh mắt bối rối nhớ thương bao ngày qua\nYêu em anh thẫn thờ\nCon tim bâng khuâng đâu có ngờ\nChẳng bao giờ phải mong chờ\nĐợi ai trong chiều hoàng hôn mờ\nĐắm chìm hòa vào vần thơ\nNgắm nhìn khờ dại mộng mơ\nĐừng bước vội vàng rồi làm ngơ\nLạnh lùng đó làm bộ dạng thờ ơ\nNhìn anh đi em nha\nHướng nụ cười cho riêng anh nha\nĐơn giản là yêu\nCon tim anh lên tiếng thôi\nCầm tay anh dựa vai anh\nKề bên anh nơi này có anh\nGió mang câu tình ca\nNgàn ánh sao vụt qua nhẹ ôm lấy em (yêu em thương em con tim anh chân thành)\nCầm tay anh dựa vai anh\nKề bên anh nơi này có anh\nKhép đôi mi thật lâu\nNguyện mãi bên cạnh nhau yêu say đắm như ngày đầu\nMùa xuân đến bình yên\nCho anh những giấc mơ\nHạ lưu giữ ngày mưa\nNgọt ngào nên thơ\nMùa thu lá vàng rơi\nĐông sang anh nhớ em\nTình yêu bé nhỏ xin\nDành tặng riêng em\nOh-oh-oh-oh nhớ thương em\nOh-oh-oh-oh nhớ thương em lắm\nAh phía sau chân trời\nCó ai băng qua lối về\nCùng em đi trên đoạn đường dài\nCầm tay anh dựa vai anh\nKề bên anh nơi này có anh\nGió mang câu tình ca\nNgàn ánh sao vụt qua nhẹ ôm lấy em (yêu em thương em con tim anh chân thành)\nCầm tay anh dựa vai anh\nKề bên anh nơi này có anh\nKhép đôi mi thật lâu\nNguyện mãi bên cạnh nhau yêu say đắm như ngày đầu\nMùa xuân đến bình yên\nCho anh những giấc mơ\nHạ lưu giữ ngày mưa\nNgọt ngào nên thơ\nMùa thu lá vàng rơi\nĐông sang anh nhớ em\nTình yêu bé nhỏ xin\nDành tặng riêng em',
    album: 'Sơn Tùng MTP',
  ),
Song(
    id: 57,
    title: 'Lạc trôi',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/l___c_tr__i.jpg',
    assetPath: 'assets/audio/l___c_tr__i.mp3',
    lyrics: 'Ah ah\nNgười theo hương hoa mây mù giăng lối\nLàn sương khói phôi phai đưa bước ai xa rồi\nĐơn côi mình ta vấn vương\nHồi ức trong men say chiều mưa buồn\nNgăn giọt lệ ngừng khiến khoé mi sầu bi\nĐường xưa nơi cố nhân từ giã biệt li cánh hoa rụng rời\nPhận duyên mong manh rẽ lối trong mơ ngày tương phùng\nOh tiếng khóc cuốn theo làn gió bay\nThuyền ai qua sông lỡ quên vớt ánh trăng tàn nơi này\nTrống vắng bóng ai dần hao gầy\nLòng ta xin nguyện khắc ghi trong tim tình nồng mê say\nMặc cho tóc mây vương lên đôi môi cay\nBâng khuâng mình ta lạc trôi giữa đời\nTa lạc trôi giữa trời\nĐôi chân lang thang về nơi đâu\nBao yêu thương giờ nơi đâu\nCâu thơ tình xưa vội phai mờ\nTheo làn sương tan biến trong cõi mơ\nMưa bụi vươn trên làn mi mắt\nNgày chia lìa hoa rơi buồn hiu hắt\nTiếng đàn ai thêm sầu tương tư lặng mình trong chiều hoàng hôn tan vào lời ca\nLối mòn đường vắng một mình ta\nNắng chiều vàng úa nhuộm ngày qua\nXin đừng quay lưng xoá\nĐừng mang câu hẹn ước kia rời xa\nYên bình nơi nào đây\nTrôn vùi theo làn mây yeah la la lá la\nNgười theo hương hoa mây mù giăng lối\nLàn sương khói phôi phai đưa bước ai xa rồi\nĐơn côi mình ta vấn vương\nHồi ức trong men say chiều mưa buồn\nNgăn giọt lệ ngừng khiến khoé mi sầu bi\nTừ xưa nơi cố nhân từ giã biệt li cánh hoa rụng rời\nPhận duyên mong manh rẽ lối trong mưa ngày tương phùng oh\nTiếng khóc cuốn theo làn gió bay\nThuyền qua sông lỡ quên vớt ánh trăng tàn nơi này\nTrống vắng bóng ai dần hao gầy\nLòng ta xin nguyện khắc ghi trong tim tình nồng mê say\nMặc cho tóc mây vương lên đôi môi cay\nBâng khuâng mình ta lạc trôi giữa đời\nTa lạc trôi giữa trời ah\nTa lạc trôi lạc trôi (lạc trôi)\nTa lạc trôi giữa đời\nLạc trôi giữa trời\nYeah ah ah\nTa đang lạc nơi nào\nTa đang lạc nơi nào\nLối mòn đường vắng một mình ta ta đang lạc nơi nào\nNắng chiều vàng úa nhuộm ngày qua ta đang lạc nơi nào oh',
  ),
  Song(
    id: 58,
    title: 'Chạy ngay đi',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/ch___y_ngay___i.png',
    assetPath: 'assets/audio/ch___y_ngay___i.mp3',
    lyrics: 'Từng phút cứ mãi trôi xa phai nhòa dần kí ức giữa đôi ta\nTừng chút nỗi nhớ hôm qua đâu về lạc bước cứ thế phôi pha\nCon tim giờ không cùng chung đôi nhịp\nNụ cười lạnh băng còn đâu nồng ấm thân quen\nVô tâm làm ngơ thờ ơ tương lai ai ngờ\nQuên đi mộng mơ ngày thơ tan theo sương mờ\nMưa lặng thầm đường vắng chiều nay\nIn giọt lệ nhòe khóe mắt sầu cay\nBao hẹn thề tàn úa vụt bay\nTrôi dạt chìm vào những giấc nồng say\nQuay lưng chia hai lối\nCòn một mình anh thôi\nGiả dối bao trùm bỗng chốc lên ngôi\nTrong đêm tối\nBầu bạn cùng đơn côi\nSuy tư anh kìm nén đã bốc cháy yêu thương trao em rồi (đốt sạch hết)\nSon môi hồng vương trên môi bấy lấu\nHương thơm dịu êm mê man bấy lâu (đốt sạch hết)\nAnh không chờ mong quan tâm nữa đâu\nTương lai từ giờ như bức tranh em quên tô màu (đốt sạch hết)\nXin chôn vùi tên em trong đớn đau\nNơi hiu quạnh tan hoang ngàn nỗi đau\nDư âm tàn tro vô vọng phía sau\nĐua chen dày vò xâu xé quanh thân xác nát nhàu\nChạy ngay đi trước khi\nMọi điều dần tồi tệ hơn\nChạy ngay đi trước khi\nLòng hận thù cuộn từng cơn\nTựa giông tố\nĐến đây ghé thăm\nTừ nơi\nHố sâu tối tăm\nChạy đi\nTrước khi\nMọi điều dần tồi tệ hơn\nKhông còn ai cạnh bên em ngày mai\nTạm biệt một tương lai ngang trái\nKhông còn ai cạnh bên em ngày mai\nTạm biệt một tương lai ngang trái\nKhông còn ai cạnh bên em ngày mai\nTạm biệt một tương lai ngang trái\nKhông còn ai cạnh bên em ngày mai\nTạm biệt một tương lai ngang trái yeah\nBuông bàn tay\nBuông xuôi hi vọng buông bình yên (buông)\nĐâu còn nguyên tháng ngày rực rỡ phai úa hằn sâu triền miên\nVết thương cứ thêm khắc thêm mãi thêm\nChà đạp vùi dập dẫm lên tiếng yêu ấm êm\nNhìn lại niềm tin từng trao giờ sao\nSau bao ngu muội sai lầm anh vẫn yếu mềm\nCăn phòng giam cầm thiêu linh hồn cô độc em trơ trọi kêu gào xót xa\nCăm hận tuôn trào dâng lên nhuộm đen ghì đôi vai đừng mong chờ thứ tha\nChính em gây ra mà\nNhững điều vừa diễn ra\nChính em gây ra mà chính em gây ra mà\nNhững điều vừa diễn ra\nHết thật rồi\nĐốt sạch hết\nSon môi hồng vương trên môi bấy lâu\nHương thơm dịu êm mê man bấy lâu (đốt sạch hết)\nAnh không chờ mong quan tâm nữa đâu\nTương lai từ giờ như bức tranh em quên tô màu\nĐốt sạch hết\nXin chôn vùi tên em trong đớn đau\nNơi hiu quạnh tan hoang ngàn nỗi đau (đốt sạch hết)\nDư âm tàn tro vô vọng phía sau\nĐua chen dày vò xâu xé quanh thân xác nát nhàu\nChạy ngay đi trước khi\nMọi điều dần tồi tệ hơn (đốt sạch)\nChạy ngay đi trước khi\nLòng hận thù cuộn từng cơn (đốt sạch)\nTựa giông tố\nĐến đây ghé thăm\nTừ nơi\nHố sâu tối tăm\nChạy đi\nTrước khi\nMọi điều dần tồi tệ hơn\nKhông còn ai cạnh bên em ngày mai\nTạm biệt một tương lai ngang trái\nKhông còn ai cạnh bên em ngày mai\nTạm biệt một tương lai ngang trái\nKhông còn ai cạnh bên em ngày mai\nTạm biệt một tương lai ngang trái\nKhông còn ai cạnh bên em ngày mai\nTạm biệt một tương lai ngang trái\nĐốt sạch hết\nOh\nChính em gây ra mà chính em gây ra mà\nĐốt sạch hết\nOh\nĐừng nhìn anh với khuôn mặt xa lạ\nXin đừng lang thang trong tâm trí anh từng đêm nữa\nQuên đi quên đi hết đi\nQuên đi quên đi hết đi\nThắp lên điều đáng thương lạnh giá ôm trọn giấc mơ vụn vỡ\nBốc cháy lên cơn hận thù trong anh (quên đi quên đi quên đi hết)\nCơn hận thù trong anh\nBốc cháy lên cơn hận thù trong anh\nAi khơi dậy cơn hận thù trong anh\nBốc cháy lên cơn hận thù trong anh (quên đi quên đi quên đi hết)\nCơn hận thù trong anh\nBốc cháy lên cơn hận thù trong anh\nAi khơi dậy cơn hận thù trong anh (phải cô đơn rồi)\nKhông còn ai cạnh bên em ngày mai\nTạm biệt một tương lai ngang trái (cô đơn rồi)\nKhông còn ai cạnh bên em ngày mai\nTạm biệt một tương lai ngang trái (cô đơn rồi)\nKhông còn ai cạnh bên em ngày mai\nTạm biệt một tương lai ngang trái (cô đơn rồi)\nKhông còn ai cạnh bên em ngày mai\nTạm biệt một tương lai ngang trái',
  ),
  Song(
    id: 59,
    title: 'Hãy trao cho anh',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/h__y_trao_cho_anh.jpg',
    assetPath: 'assets/audio/h__y_trao_cho_anh.mp3',
    lyrics: 'Lala lala lala\nHình bóng ai đó nhẹ nhàng vụt qua nơi đây\nQuyến rũ ngây ngất loạn nhịp làm tim mê say\nCuốn lấy áng mây theo cơn sóng xô dập dìu\nNụ cười ngọt ngào cho ta tan vào phút giây miên man quên hết con đường về eh\nLet me know your name\nChẳng thể tìm thấy lối về eh\nLet me know your name\nĐiệu nhạc hòa quyện trong ánh mắt đôi môi\nDẫn lối những bối rối rung động khẽ lên ngôi\nVà rồi khẽ và rồi khẽ khẽ\nChạm nhau mang vô vàn đắm đuối vấn vương dâng tràn\nLấp kín chốn nhân gian làn gió hoá sắc hương mơ màng\nMột giây ngang qua đời cất tiếng nói không nên lời\nẤm áp đến trao tay ngàn sao trời thêm chơi vơi\nDịu êm không gian bừng sáng đánh thức muôn hoa mừng\nQuấn quít hát ngân nga từng chút níu bước chân em dừng\nBao ý thơ tương tư ngẩn ngơ (la la la)\nLưu dấu nơi mê cung đẹp thẫn thờ\nOh oh oh oh uh\nHãy trao cho anh hãy trao cho anh\nHãy trao cho anh thứ anh đang mong chờ (oh oh oh oh)\nHãy trao cho anh hãy trao cho anh\nHãy mau làm điều ta muốn vào khoảnh khắc này đê (oh oh oh oh)\nHãy trao cho anh đê hãy trao cho anh đê\nHãy trao anh trao cho anh đi những yêu thương nồng cháy (chỉ mình anh thôi)\nTrao anh ái ân nguyên vẹn đong đầy\nLala lala\nLala lala\nLala lala\nLala lala\nLooking at my Gucci is about that time\nWe can smoke a blunt and pop a bottle of wine\nNow get yourself together and be ready by nine\nCuz we gon\' do some things that will shatter your spine\nCome one undone Snoop Dogg Son Tung\nLong Beach is the city that I come from\nSo if you want some get some\nBetter enough take some take some\nChạm nhau mang vô vàn đắm đuối vấn vương dâng tràn\nLấp kín chốn nhân gian làn gió hóa sắc hương mơ màng\nMột giây ngang qua đời cất tiếng nói không nên lời\nẤm áp đến trao tay ngàn sao trời lòng càng thêm chơi vơi\nDịu êm không gian bừng sáng đánh thức muôn hoa mừng\nQuấn quít hát ngân nga từng chút níu bước chân em dừng\nBao ý thơ tương tư ngẩn ngơ (la la la)\nLưu dấu nơi mê cung đẹp thẫn thờ\nOh oh oh oh uh\nHãy trao cho anh hãy trao cho anh\nHãy trao cho anh thứ anh đang mong chờ (oh oh oh oh)\nHãy trao cho anh hãy trao cho anh\nHãy mau làm điều ta muốn vào khoảnh khắc này đê (oh oh oh oh)\nHãy trao cho anh đê hãy trao cho anh đê\nHãy trao anh trao cho anh đi những yêu thương nồng cháy (chỉ mình anh thôi)\nTrao anh ái ân nguyên vẹn đong đầy\nLala lala\nLala lala\nLala lala\nLala lala\nLàm cho ta ngắm thêm nàng vội vàng qua chốc lát\nNhư thanh âm chứa bao lời gọi mời trong khúc hát\nLiêu xiêu ta xuyến xao rạo rực khát khao trông mong\nDịu dàng lại gần nhau hơn dang tay ôm em vào lòng\nThôi trao đi trao hết đi đừng ngập ngừng che dấu nữa\nQuên đi quên hết đi ngại ngùng lại gần thêm chút nữa\nChìm đắm giữa khung trời riêng hai ta như dần hòa quyện\nMắt nhắm mắt tay đan tay hồn lạc về miền trăng sao\nBuông lơi cho ta ngắm thêm nàng vội vàng qua chốc lát\nNhư thanh âm chứa bao lời gọi mời trong khúc hát\nLiêu xiêu ta xuyến xao rạo rực khát khao trông mong\nDịu dàng lại gần nhau hơn dang tay ôm em vào lòng\nTrao đi trao hết đi đừng ngập ngừng che dấu nữa\nQuên đi quên hết đi ngại ngùng lại gần thêm chút nữa\nChìm đắm giữa khung trời riêng hai ta như dần hòa quyện\nMắt nhắm mắt tay đan tay hồn lạc về miền trăng sao\nHãy trao cho anh hãy trao cho anh (let\'s go)\nHãy trao cho anh cho anh cho anh (lala)\nHãy trao cho anh hãy trao cho anh\nHãy trao cho anh cho anh cho anh (lala)\nHãy trao cho anh hãy trao cho anh\nHãy trao cho anh cho anh cho anh (lala)\nHãy trao cho anh hãy trao cho anh\nHãy trao cho anh thứ anh đang mong chờ',
  ),
  Song(
    id: 60,
    title: 'Có chắc yêu là đây',
    artist: 'Sơn Tùng MTP',
    coverImage: 'assets/images/c___ch___c_y__u_l_______y.jpg',
    assetPath: 'assets/audio/c___ch___c_y__u_l_______y.mp3',
    lyrics: '… Good boy\n… Thấp thoáng ánh mắt đôi môi mang theo hương mê say\nEm cho anh tan trong miên man quên luôn đi đêm ngày\nChạm nhẹ vội vàng hai ba giây nhưng con tim đâu hay\nBối rối khẽ lên ngôi yêu thương đong đầy thật đầy\n… Anh ngẩn ngơ cứ ngỡ\n(Đó chỉ là giấc mơ)\nAnh ngẩn ngơ cứ ngỡ\n(Như đang ngất ngây trong giấc mơ)\nThật ngọt ngào êm dịu đắm chìm\nPhút chốc viết tương tư gieo nên thơ (yeah, hey)\n… Có câu ca trong gió hát ngân nga, ru trời mây\nNhẹ nhàng đón ban mai ngang qua trao nụ cười (trao nụ cười)\nNắng đua chen, khoe sắc, vui đùa giữa muôn ngàn hoa\nDịu dàng đến nhân gian âu yếm tâm hồn người\n… Hình như chính em\n(Cho anh mong chờ)\nHình như chính là em\n(Cho anh vấn vương)\nĐừng thờ ơ, xin hãy lắng nghe\nVà giúp anh trả lời đôi điều còn băn khoăn\n… Có chắc yêu là đây, đây, đây\nCó chắc yêu là đây, đây\nCó chắc yêu là đây, đây, đây\nCó chắc yêu là đây, đây\n… Em lang thang cả ngày trong tâm trí\nĐi không ngừng cả ngày trong tâm trí\nSi mê thêm cuồng quay\nOo-ooh, oo-oo-oo-ooh\n… Chắc gì nữa mà chắc\nSáng thì nhớ đêm trắng tương tư còn không phải yêu là gì\n(Có chắc yêu là đây)\nRồi thắc gì nữa mà mắc\nĐến bên nắm tay nói ra ngay ngồi mơ mộng thêm làm gì\n… Nhanh chân chạy mua một bó hoa (hey)\nThêm luôn một món quà (hooh)\nKhuôn mặt tươi cười lên vô tư gạt đi lo âu mạnh mẽ nha\nVà rồi bước ra, bước ra, bước ra (hey)\n… Có câu ca trong gió hát ngân nga, ru trời mây\nNhẹ nhàng đón ban mai ngang qua trao nụ cười (trao nụ cười)\nNắng đua chen, khoe sắc, vui đùa giữa muôn ngàn hoa\nDịu dàng đến nhân gian âu yếm tâm hồn người\n… Hình như chính em\n(Cho anh mong chờ)\nHình như chính là em\n(Cho anh vấn vương)\nĐừng thờ ơ, xin hãy lắng nghe\nVà giúp anh trả lời đôi điều còn băn khoăn\n… Có chắc yêu là đây, đây, đây\nCó chắc yêu là đây, đây\nCó chắc yêu là đây, đây, đây\nCó chắc yêu là đây, đây\n… Em lang thang cả ngày trong tâm trí\nĐi không ngừng cả ngày trong tâm trí\nSi mê thêm cuồng quay\nOo-ooh, oo-oo-oo-ooh\n… Có chắc yêu là đây (a-ah, a-ah)\nCó chắc yêu là đây (ooh-ooh, oo-ooh)\nCó chắc yêu là đây (a-ah)\n… Please come to me! (Please come to me!)\nPlease come to me!\n… Có chắc yêu là đây, đây, đây\nCó chắc yêu là đây, đây\nCó chắc yêu là đây, đây, đây\nCó chắc yêu là đây, đây\n… Em lang thang cả ngày trong tâm trí\nĐi không ngừng cả ngày trong tâm trí\nSi mê thêm cuồng quay\nOo-ooh, oo-oo-oo-ooh\n… M-TP\n(Có chắc yêu là đây, đây) Một bài hát\nDành đến cho tất cả những ai đang yêu (có chắc yêu là đây, đây, đây)\nChưa yêu, và sẽ được yêu (có chắc yêu là đây, đây)\nHạnh phúc nhá!',
  ),
];
