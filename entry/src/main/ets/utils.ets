import { uniformTypeDescriptor } from '@kit.ArkData';

export class DateUtils{
  public static  ToString(num:number, notime:boolean = false):string {
    let date:Date = new Date(num)
    const year = date.getFullYear().toString()
    const month = (date.getMonth() + 1).toString().padStart(2,'0') //看到这个+1了吗，传承30年的屎山，跨越四门语言，2025年的今天还在恶心人
    const day = date.getDate().toString().padStart(2,'0')
    const hour = date.getHours().toString().padStart(2,'0')
    const minute = date.getMinutes().toString().padStart(2,'0')
    if (notime) return year+'/'+month+'/'+day
    return year+'/'+month+'/'+day+' '+hour+':'+minute
  }
  public static _ToStringForTimeSpan(num:number):string {
    console.log(num.toString())
    if (num<0) return '不限';
    else return DateUtils.ToString(num)
  }
}

export class FileType{
  public static getFileType(uri:string):string{
    let extension:string=''
    try {
      extension = uri.substring(uri.lastIndexOf('.'))
    }catch (e){
      extension = ''
      return ''
    }
    try {
      let typeId = uniformTypeDescriptor.getUniformDataTypeByFilenameExtension(extension);
      let typeObj = uniformTypeDescriptor.getTypeDescriptor(typeId);
      let mimeTypes = typeObj.mimeTypes;
      return mimeTypes[0]
    } catch (err) {
      console.error('err message:' + err.message + ', err code:' + err.code);
    }
    return ''
  }
}