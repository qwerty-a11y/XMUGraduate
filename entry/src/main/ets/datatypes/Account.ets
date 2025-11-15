export abstract class Account{
  constructor(ID:string, Name:string) {
    this.ID=ID
    this.Name=Name
  }
  public ID:string
  public Name:string
}

export class Student extends Account{
  constructor(ID:string, Name:string, Score:number) {
    super(ID,Name)
    this.Score=Score
  }
  public Score:number
}

export class Teacher extends Account{
  constructor(ID:string, Name:string) {
    super(ID,Name)
  }
}