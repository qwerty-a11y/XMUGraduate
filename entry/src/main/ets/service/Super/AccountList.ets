import { Account } from "../../datatypes/Account";
import { Request } from '../../datatypes/Feedback'
import { BusinessError } from "@kit.BasicServicesKit";
import { promptAction, router } from "@kit.ArkUI";
import { http } from "@kit.NetworkKit";
import { DynamicData, StaticData } from "../../constants";
import json from "@ohos.util.json";

interface feedbacks{
  feedbacks:Request[]
}
interface empty{}

@Observed
export class AccountList{
  public static Type:number = 0; //0=同专业学生，1=全体学生，2=老师
  public static StuMajor:boolean[] = [false, false, false, false, false]
  public static Major():number{
    let idx:number = -1;
    AccountList.StuMajor.forEach((element,index) => {
      if (element == true) {
        if (idx==-1) idx=index;
      }
    });
    return idx
  }
  public static List:Account[] = []
}

@Observed
export class FeedBacks{
  public static List:Request[] = []
  public static async Refresh(){
    let httpRequest = http.createHttp();
    try {
      let Response: http.HttpResponse = await httpRequest.request(
        StaticData.ServerURL + '/api/feedback/list/',
        {
          method: http.RequestMethod.GET,
          header: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Token '+DynamicData.token
          }
        }
      )

      let DataObj: feedbacks | empty
      let DataObjTmp: object | null
      try {
        DataObjTmp = json.parse(Response.result.toString())
        DataObj = DataObjTmp ? DataObjTmp : {}

        if (Response.responseCode == 200) {
          FeedBacks.List = (DataObj as feedbacks).feedbacks;
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