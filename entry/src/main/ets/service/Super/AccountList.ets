import List from "@ohos.util.List";
import * as TypeRecord from '../../datatypes/Record'

@Observed
export class AccountList{
  public static Type:number = 0; //0=同专业学生，1=全体学生，2=老师
  public static StuMajor:boolean[] = [false, false, false, false, false]
}