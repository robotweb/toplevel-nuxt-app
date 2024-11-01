export interface CustomerResponse {
  id: string;
  name: string;
  billingAddress: string;
  clientMarkup: number;
  contacts: ContactModel[];
}

export interface ContactModel {
  name: string;
  surName: string;
  email: string;
  phoneNumber: string;
  mobileNumber: string;
}
