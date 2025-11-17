import {HttpFileManager} from '../service/HttpFileManager'
import { common } from '@kit.AbilityKit';
import {UploadOptions,DownloadOptions,HeadersObject,FormDataItem,FileItem,EmptyObject} from  '../datatypes/File'
import { StaticData } from '../constants';

@Component
export struct UploadFile{
  private context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
  @State FileList:FileItem[] = []
  @Watch('Upload')
  @State public UploadTrigger:boolean = false
  @BuilderParam ReadOnly:boolean
  @Prop image_file: ResourceStr = $r("app.media.File");
  @Prop image_remove: ResourceStr = $r("app.media.Remove");
  @Prop image_add: ResourceStr = $r("app.media.Add");

  async Upload(){
    HttpFileManager.upload(this.context,{
      url:StaticData.ServerURL+'/api/student/material/applications/fileupload',
      files:this.FileList
    })
  }

  build() {
    Column(){
      ForEach(this.FileList,(item:FileItem,index:number)=>{
        Row({space:10}){
          Image(this.image_file).width('5%').margin({left:'5%',right:'5%'})
          Text(item.filename).width('70%')
          if (!this.ReadOnly) Image(this.image_remove).width('3%').margin({left:'6%',right:'6%'})
        }
      })
      if (!this.ReadOnly) {
        Image(this.image_add).height(40)
      }
    }
  }
}