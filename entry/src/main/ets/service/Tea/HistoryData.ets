import List from "@ohos.util.List";
import * as TypeRecord from '../../datatypes/Record'
import { http } from "@kit.NetworkKit";
import { DynamicData, StaticData } from "../../constants";
import json from "@ohos.util.json";
import { promptAction, router } from "@kit.ArkUI";
import { BusinessError } from "@kit.BasicServicesKit";

interface Application{
  Type:number
  Title:string
  ApplyScore:number
  RealScore:number
  ReviewStatus:number //0=未提交，1=审核中，2=审核通过，3=审核失败
  UploadTime:number
  ModifyTime:number
  Description:string
  Attachments: TypeRecord.Attachment[]
  FeedBack:string
  extra_data:string
}

interface data{
  ApplyList?: Application[]
}

interface empty{

}

@Observed
export class HistoryData{
  public static HistoryList:TypeRecord.RecordEntry[]=[]
  public static Filters:TypeRecord.Filter=new TypeRecord.Filter()
  public static FilteredList:TypeRecord.RecordEntry[]=[]
  public static SearchText:string=""

  public static Filter(){
    HistoryData.FilteredList=[]
    HistoryData.HistoryList.forEach((value)=>{
      if (
        (
          !HistoryData.Filters.EnableStatus ||
          HistoryData.Filters.ReviewStatus[value.ReviewStatus]
        ) &&
        (
          !HistoryData.Filters.EnableType ||
          HistoryData.Filters.Type[value.Type.valueOf()]
        ) &&
        (
          HistoryData.Filters.UploadTime.start < 0 ||
          HistoryData.Filters.UploadTime.start <= value.UploadTime
        ) &&
        (
          HistoryData.Filters.UploadTime.end < 0 ||
          HistoryData.Filters.UploadTime.end >= value.UploadTime
        ) &&
        (
          HistoryData.Filters.ModifyTime.start < 0 ||
          HistoryData.Filters.ModifyTime.start <= value.ModifyTime
        ) &&
        (
          HistoryData.Filters.ModifyTime.end < 0 ||
          HistoryData.Filters.ModifyTime.end >= value.ModifyTime
        ) &&
        value.Title.includes(HistoryData.SearchText))
      {
        HistoryData.FilteredList.push(value)
      }
    })
  }
  public static async refresh(){
    let httpRequest = http.createHttp();
    try {
      let Response: http.HttpResponse = await httpRequest.request(
        StaticData.ServerURL + '/api/student/material/reviews/history/',
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token '+DynamicData.token
          }
        }
      )

      let DataObj: data | empty
      let DataObjTmp: object | null
      try {
        DataObjTmp = json.parse(Response.result.toString())
        DataObj = DataObjTmp ? DataObjTmp : {}

        if (Response.responseCode == 200 && DataObj && (DataObj as data).ApplyList) {
          const applyList = (DataObj as data).ApplyList;
          HistoryData.HistoryList = []

          for (const item of applyList!) {
            // 创建RecordEntry对象
            const recordEntry = new TypeRecord.RecordEntry(
              item.Type,
              item.Title,
              item.ApplyScore,
              item.ReviewStatus,
              item.Description,
              item.UploadTime,
              item.ModifyTime
            );

            recordEntry.RealScore = item.RealScore;
            recordEntry.Attachments = item.Attachments || [];
            recordEntry.FeedBack = item.FeedBack || '';

            // 解析extra_data
            if (item.extra_data && item.extra_data !== '') {
              try {
                const extraDataObj:object = JSON.parse(item.extra_data);
                let typeInfo: TypeRecord.TypeInfo | undefined;

                // 根据Type字段创建对应的TypeInfo对象
                switch (item.Type) {
                  case 0: // 学业竞赛
                    typeInfo = new TypeRecord.Competition();
                    break;
                  case 1: // 创新创业训练
                    typeInfo = new TypeRecord.Innovation();
                    break;
                  case 2: // 科研成果
                    typeInfo = new TypeRecord.Research();
                    break;
                  case 3: // 荣誉称号
                    typeInfo = new TypeRecord.Honor();
                    break;
                  case 4: // 社会工作
                    typeInfo = new TypeRecord.SocialWork();
                    break;
                  case 5: // 志愿服务
                    typeInfo = new TypeRecord.Volunteer();
                    break;
                  case 6: // 国际组织学习
                    typeInfo = new TypeRecord.International();
                    break;
                  case 7: // 参军入伍
                    typeInfo = new TypeRecord.Military();
                    break;
                  case 8: // 体育比赛
                    typeInfo = new TypeRecord.Sports();
                    break;
                  default:
                    console.warn('Unknown record type:', item.Type);
                }

                if (typeInfo) {
                  // 调用fromJSON方法解析数据
                  typeInfo.fromJSON(item.extra_data);
                  recordEntry.extra_data = typeInfo;
                }
              } catch (parseError) {
                console.error('Error parsing extra_data:', parseError);
              }
            }

            HistoryData.HistoryList.push(recordEntry);
          }
          HistoryData.Filter()


        } else if (DataObj && Object.keys(DataObj).includes('detail')) {
          promptAction.showToast({
            message: '登录失效，请重新登录',
            duration: 2000
          });
          router.pushUrl({ url: 'pages/Login' })
        } else {
          promptAction.showToast({
            message: '刷新失败，请检查网络连接',
            duration: 2000
          });
        }
      } catch (e) {
        let error = e as BusinessError
        let msg = error?.message
        promptAction.showToast({
          message: '解析错误：' + msg,
          duration: 2000
        });
        return;
      }
    } catch (e) {
      let err: BusinessError = e as BusinessError
      console.log(err.message)
      console.log(err.name)
    }
  }
}