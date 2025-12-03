export interface StudentDetail{
  name:string,
  department:string,
  phone:string,
  email:string,
  rank:number[],
  academy_score:number,
  score:number,
  cet4:number,
  cet6:number,
  applications_score:number[],
  applications_approved:number,
  applications_rejected:number
}

export interface TeacherDetail{
  name:string,
  department:string,
  phone:string,
  email:string,
}