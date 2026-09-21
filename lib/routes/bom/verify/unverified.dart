import 'package:wkl_mobile/index.dart';
import 'package:wkl_mobile/zjc_module/utils/zjc_common_utils.dart';
import 'package:wkl_mobile/zjc_module/zjc_form/zjc_searchbar.dart';

class PurchaseUnVerified extends StatefulWidget {
  const PurchaseUnVerified({super.key});

  @override
  State<PurchaseUnVerified> createState() => _PurchaseUnVerifiedState();
}

class _PurchaseUnVerifiedState extends State<PurchaseUnVerified> {

  // 翻页标识
  var _items = <PurchaseItem>[PurchaseItem(id: 'loadingTag')];
  bool hasMore = true;
  int pageNum = 1;
  // 搜索栏数据
  String searchBarText = "";

    // 获取待核验列表
  void getPurchaseList() async {
    Map<String, dynamic> queryParameters = {
      'pageNum': pageNum,
      'pageSize': 10,
      'state': 5,
      'purchaseId': searchBarText,
    };
    var r = await VerifyApi().purchaseVerifyQuery(
      queryParameters: queryParameters
    );
    if(r.statusCode == 200){
      var verifyList = PurchaseList.fromJson(r.data['data']);
      setState(() {
        hasMore = !(verifyList.isLastPage!);
        _items.insertAll(_items.length - 1, verifyList.list);
        pageNum++;
      });
    }else{
      showToast('待核验列表为空');
    }
  }

  // 搜索框查询
  void search(){
    setState(() {
      pageNum = 1;
      hasMore = true;
      _items = <PurchaseItem>[PurchaseItem(id: 'loadingTag')];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ZjcSearchBar(
            hintText: "请输入采购订单号",
            inputCompletionCallBack:(value, isSubmitted) {
              searchBarText = value;
              if(isSubmitted){
                ZjcCommonUtils.debounce(() => search(), 500);
              }
            },
          ),
          Container(
            alignment: Alignment.topCenter,
            height: (MediaQuery.of(context).size.height)*0.8,
            child: ListView.separated(
              itemCount: _items.length,
              itemBuilder: (context,index){
                if(_items[index].id == 'loadingTag'){
                  //单次加载容量
                  if(hasMore){
                    // 请求请料表数据
                    getPurchaseList();
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 24.0,
                        height: 24.0,
                        child: CircularProgressIndicator(strokeWidth: 2.0,)
                      ),
                    );
                  }else{
                    return Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(16),
                      child: Text("没有更多待处理的作业内容了",
                        style: TextStyle(color: Colors.blue[700]),
                      ),
                    );
                  }
                }
                return newItemwidget(_items[index]);
              }, 
              separatorBuilder: (context,index) => const SizedBox(height: .0,), 
            )
          )
        ]
      ),
    );
  }

  Widget newItemwidget(PurchaseItem item){
    var cell = Padding(
      padding: const EdgeInsets.all(5),
      child: GestureDetector(
        child:Container(
          margin: const EdgeInsets.all(3),
          padding: const EdgeInsets.only(left: 10,right: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black54,
                offset: Offset(2.0, 2.0),
                blurRadius: 4.0
              )
            ],
          ),
          child:  Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('物料编码：${item.materialCode}',style: TextStyle(color: Colors.blueGrey),),
                    Text('规格型号：${item.model}',style: TextStyle(color: Colors.blueGrey),),
                  ],
                ),
                const SizedBox( height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width*0.5,
                      child: Text('${item.materialName}',softWrap: true,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(height:60,width: MediaQuery.of(context).size.width*0.3),
                      child: ElevatedButton.icon(
                      onPressed: ()=>{}, 
                      style: ElevatedButton.styleFrom(
                        shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.all(1.0),
                        backgroundColor: Color(0xff68abcc)
                      ),
                      label: Text('${item.requireDepartment}',softWrap: true,maxLines: 2,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      icon: Icon(Icons.person,color: Colors.white,),),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints.expand(height: 25,width: 120),
                      child: ElevatedButton(onPressed: ()=>{},
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(1),
                          backgroundColor: const Color(0xff001e64),
                        ),
                        child: Text('采购数量   ${formattedNum(item.purchaseNum!)}',style: TextStyle(color: Colors.white),)
                      ),
                    ),
                    Text('采购方式：${item.purchaseType}',style: TextStyle(color: Color(0xff6192b3)),),
                    SizedBox(
                      // width: 150,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: (item.state == 5?Color(0xff888888):Color(0xff04641d)),
                              shape: BoxShape.circle
                            ),
                            child: Text(item.state == 5?'已到货':'已核验', style: TextStyle(color: const Color.fromARGB(255, 43, 17, 17))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5,)
              ],
            ),
        ),
        onTap: () {
          if(item.state != 5){
            showToast('已验收过');
          }else{

          }
        }
      ),
    );
    return cell;
  }
}
