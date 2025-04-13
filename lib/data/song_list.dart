class Song {
  final int id;
  final String title;
  final String artist;
  final String coverImage;
  final String assetPath;
  final String lyrics;
  final String? album;
  bool isFavorite;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.coverImage,
    required this.assetPath,
    required this.lyrics,
    this.album,
    this.isFavorite = false,
  });
}

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
  return userFavorites.any((favorite) => 
    favorite.songId == songId && favorite.userId == userId
  );
}

// Thêm hoặc xóa bài hát khỏi danh sách yêu thích
void toggleFavorite(int songId, String userId) {
  final existingIndex = userFavorites.indexWhere(
    (favorite) => favorite.songId == songId && favorite.userId == userId
  );
  
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
    artist: 'RPT MCK',
    coverImage: 'assets/images/chim_sau.png',
    assetPath: 'assets/audio/chim_sau.mp3',
    lyrics: '''Em đi qua con phố
Đèn xanh đỏ vẫn sáng
Anh như đang ngồi đó
Nhưng tim thì vắng lặng...''',
  ),
  Song(
    id: 3,
    title: 'Tại Vì Sao',
    artist: 'RPT MCK',
    coverImage: 'assets/images/tai_vi_sao.png',
    assetPath: 'assets/audio/tai_vi_sao.mp3',
    lyrics: '''Em đi qua con phố
Đèn xanh đỏ vẫn sáng
Anh như đang ngồi đó
Nhưng tim thì vắng lặng...''',
  ),
  Song(
    id: 4,
    title: 'Chúng Ta Của Hiện Tại',
    artist: 'Sơn Tùng M-TP',
    coverImage: 'assets/images/chung_ta_cua_hien_tai.png',
    assetPath: 'assets/audio/chung_ta_cua_hien_tai.mp3',
    lyrics: '''Em đi qua con phố
Đèn xanh đỏ vẫn sáng
Anh như đang ngồi đó
Nhưng tim thì vắng lặng...''',
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
    lyrics: '''Em đi qua con phố
Đèn xanh đỏ vẫn sáng
Anh như đang ngồi đó
Nhưng tim thì vắng lặng...''',
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
    id: 12,
    title: 'Vì chúng ta là con người',
    artist: 'Ronboogz | HHBO | HWinno',
    coverImage: 'assets/images/v___ch__ng_ta_l___con_ng_____i.jpg',
    assetPath: 'assets/audio/v___ch__ng_ta_l___con_ng_____i.mp3',
    lyrics:
        'Tại sao mà em vẫn khóc đến hết nước mắt, chỉ vì một người?\nTại sao mà bao chuyện cũ nó vẫn, cứ trở về cùng một nơi?\nTại sao khi em đã biết chỉ có dối trá, ở trong cuộc đời?\nMà em vẫn luôn đem hết con tim đó, đánh cược thôi?\nChỉ bởi vì chúng ta là con người, con người\nChỉ bởi vì chúng ta là con người, con người\nChỉ bởi vì chúng ta là con người, con người\nLà hạt sạn tí hon ở trong đời, trong đời em ơi\nEm đã biết anh ta chỉ muốn chơi đùa thôi\nVậy tại sao hôm qua em hỏi "anh có đang lừa dối"\nVậy tại sao em bấm nhấc máy khi anh ta gọi đến?\nVà lại vội quên bao mất mát đang gọi tên\nRồi niềm đau nhồi lên em như em đã chắc từ đầu\nEm ngồi bên thềm và nước mắt tự lau\nEm gục ngã khi đôi chân em lắc lư\nEm chìm vào giấc ngủ\nKhi chưa biết gỡ nút thắc từ đâu\nVà để rồi mình anh vẫn lặng im\nKhi chuyện của em như mình tiên tri\nBiết chắc là đớn đau mà em vẫn kiên trì\nAnh ngước mắt và vẽ khói\nTrước mắt là cả thế giới\nGạt nước mắt của em lăn trên mi\nNhưng cuộc đời đâu dễ như thế đâu em\nVì em chỉ cần người em thương\nVì cuộc đời đâu dễ như thế đâu em\nKhi anh chỉ là người bên đường\nTại sao mà em vẫn khóc đến hết nước mắt, chỉ vì một người?\nTại sao mà bao chuyện cũ nó vẫn, cứ trở về cùng một nơi?\nTại sao khi em đã biết chỉ có dối trá, ở trong cuộc đời?\nMà em vẫn luôn đem hết con tim, đó đánh cược thôi?\nChỉ bởi vì chúng ta là con người, con người\nChỉ bởi vì chúng ta là con người, con người\nChỉ bởi vì chúng ta là con người, con người\nLà hạt sạn tí hon ở trong đời\nTrong đời em ơi\nEm y như áng mây trôi theo ánh trăng bay đi khắp nơi ye\nBan xuống nơi thế gian bầu trời bình yên\nBởi vì người ta thì đâu có hay\nTrong tim của em hình bóng vẫn như vậy\nAnh biết em chỉ muốn tìm được tình duyên\nVì chúng ta là con người, ngàn tiếng ca ở trong đời\nNhiều lúc ta chỉ muốn hát lên, bài nhạc những giai điệu vang trời\nEm sẽ không còn hay buồn, trời đất không còn quay cuồng\nNhiều lúc ta sẽ cùng với nhau hẹn thề, với nhau dưới cánh buồm\nVà dòng thời gian kia nó sẽ trôi qua vội vàng\nĐừng bận lòng chi nữa về những cái thứ không liên quan\nMuộn phiền trải qua cùng với những thứ em còn mang\nĐường mình về chung lối và cùng thức giấc khi trời sáng\nBên em dù nắng hay mưa rào, khó khăn thế nào\nAnh sẽ cùng em bước vượt qua\nTa đã dành hết cho nhau\nNhững đau thương sâu\nMong cho em hạnh phúc dài lâu\nTại sao mà em vẫn khóc đến hết nước mắt, chỉ vì một người?\nTại sao mà bao chuyện cũ nó vẫn, cứ trở về cùng một nơi?\nTại sao khi em đã biết chỉ có dối trá, ở trong cuộc đời?\nMà em vẫn luôn đem hết con tim, đó đánh cược thôi?\nChỉ bởi vì chúng ta là con người, con người\nChỉ bởi vì chúng ta là con người, con người\nChỉ bởi vì chúng ta là con người, con người\nLà hạt sạn tí hon ở trong đời\nTrong đời em ơi',
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
];
