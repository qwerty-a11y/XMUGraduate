import { HistoryData } from "./HistoryData"

export class BasicData{
  public static departments:string=''
  public static clear(){
    BasicData.departments=''
    HistoryData.HistoryList=[]
    HistoryData.FilteredList=[]
  }
}