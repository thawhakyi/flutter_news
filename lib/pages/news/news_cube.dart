import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:FlutterNews/repository/notice_repository/notice_repository.dart';
import 'package:FlutterNews/support/conection/api.dart';
import 'package:cubes/cubes.dart';

class NewsCube extends Cube {
  final NoticeRepository repository;

  int _page = 0;
  int _currentCategory = 0;
  List<String> _categories = ['geral', 'sports', 'technology', 'entertainment', 'health', 'business'];

  NewsCube(this.repository) {
    categoriesName.add(Cubes.getString("cat_geral"));
    categoriesName.add(Cubes.getString("cat_esporte"));
    categoriesName.add(Cubes.getString("cat_tecnologia"));
    categoriesName.add(Cubes.getString("cat_entretenimento"));
    categoriesName.add(Cubes.getString("cat_saude"));
    categoriesName.add(Cubes.getString("cat_negocios"));
  }

  final errorConnection = ObservableValue<bool>(value: false);
  final progress = ObservableValue<bool>(value: false);
  final noticeList = ObservableList<Notice>(value: []);
  final categoriesName = ObservableList<String>(value: []);

  @override
  void ready() {
    load(false);
    super.ready();
  }

  void categoryClick(int position) {
    _currentCategory = position;
    load(false);
  }

  void load(bool isMore) {
    if (!progress.value) {
      if (isMore) {
        _page++;
      } else {
        noticeList.clear();
        _page = 0;
      }

      errorConnection.update(false);

      progress.update(true);

      String category = _categories[_currentCategory];

      repository.loadNews(category, _page).then((news) => _showNews(news, isMore)).catchError(_showImplError);
    }
  }

  _showNews(List<Notice> news, bool isMore) {
    progress.update(false);

    if (isMore) {
      noticeList.addAll(news);
    } else {
      noticeList.update(news);
    }
  }

  _showImplError(onError) {
    if (onError is FetchDataException) {
      print("codigo: ${onError.code()}");
    }
    errorConnection.update(true);
    progress.update(false);
  }
}
