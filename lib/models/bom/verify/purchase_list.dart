import 'package:json_annotation/json_annotation.dart';
import 'package:wkl_mobile/models/global/pagelist.dart';
part 'purchase_list.g.dart';

@JsonSerializable()
class PurchaseList extends PageList {

  PurchaseList({
        super.total,
        required this.list,
        super.pageNum,
        super.pageSize,
        super.size,
        super.startRow,
        super.endRow,
        super.pages,
        super.prePage,
        super.nextPage,
        super.isFirstPage,
        super.isLastPage,
        super.hasPreviousPage,
        super.hasNextPage,
        super.navigatePages,
        super.navigatepageNums,
        super.navigateFirstPage,
        super.navigateLastPage,
  });

  List<PurchaseItem> list;

  factory PurchaseList.fromJson(Map<String,dynamic> json) => _$PurchaseListFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PurchaseListToJson(this);
}

@JsonSerializable()
class PurchaseItem {

    String? createTime;
    String? typeStorePlaceName;
    int? state;
    String? purchaseId;
    String? purchaseType;
    double? purchaseNum;
    String? purchaseListTitleCode;
    String? materialCode;
    String? materialName;
    String? model;
    String? numUnit;
    int? num;
    String? requireDepartment;
    String? planType;
    String? claimName;
    String? contractId;
    String? storePlaceName;
    String? storeLocationName;
    String? id;
    String? batchNum;
    int? verifyStep;
    String? planApplyTime;
    String? storePlaceId;
    String? storeLocationId;
    String? isBatch;
    double? menuPrice;
    int? amount;
    String? supplierName;
    bool? isSpireMaterial;
    bool? isDictionaryContract;
    double? prePrice;
    String? planId;
    String? putinId;
    String? nineSevenCode;
    String? flowId;
    String? planAgree;
    String? planRemark;
    double? purchasePrice;
    String? transportTime;
    String? receiveTime;
    String? claimTime;
    String? claimId;
    String? createName;
    String? transportName;
    String? receiveName;
    String? requireDepartmentId;
    double? verifyNum;
    String? verifyName;
    String? verifyTime;
    String? costType;
    String? brand;
    String? type;
    String? receiveModel;
    double? receiveNum;
    String? receiveBrand;
    String? productionId;
    String? produceTime;
    String? qualityPeriod;
    String? qualitySituation;
    String? verifyConclusion;
    String? verifyRemark;

    PurchaseItem({
      this.createTime,
      this.typeStorePlaceName,
      this.state,
      this.purchaseId,
      this.purchaseType,
      this.purchaseNum,
      this.purchaseListTitleCode,
      this.materialCode,
      this.materialName,
      this.model,
      this.numUnit,
      this.num,
      this.requireDepartment,
      this.planType,
      this.claimName,
      this.contractId,
      this.storePlaceName,
      this.storeLocationName,
      this.id,
      this.batchNum,
      this.verifyStep,
      this.planApplyTime,
      this.storePlaceId,
      this.storeLocationId,
      this.isBatch,
      this.menuPrice,
      this.amount,
      this.supplierName,
      this.isSpireMaterial,
      this.isDictionaryContract,
      this.prePrice,
      this.planId,
      this.putinId,
      this.nineSevenCode,
      this.flowId,
      this.planAgree,
      this.planRemark,
      this.purchasePrice,
      this.transportTime,
      this.receiveTime,
      this.claimTime,
      this.claimId,
      this.createName,
      this.transportName,
      this.receiveName,
      this.requireDepartmentId,
      this.verifyNum,
      this.verifyName,
      this.verifyTime,
      this.costType,
      this.brand,
      this.type,
      this.receiveModel,
      this.receiveNum,
      this.receiveBrand,
      this.productionId,
      this.produceTime,
      this.qualityPeriod,
      this.qualitySituation,
      this.verifyConclusion,
      this.verifyRemark,
    });
  
  factory PurchaseItem.fromJson(Map<String,dynamic> json) => _$PurchaseItemFromJson(json);
  Map<String, dynamic> toJson() => _$PurchaseItemToJson(this);
}