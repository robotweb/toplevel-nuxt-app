export interface QuotationCreateRequest {
  quotationId: string;
  businessName: string;
  customerReference: string;
  clientName: string;
  clientEmail: string;
  clientContact: string;
  vatPercentage: number;
  subTotal: number;
  totalCost: number;
  totalCostVat: number;
  invoicedToDateAmount: number;
  dateIssued: string;
  validUntil: string;
  quotationType: QuotationType;
  quoteItems: QuoteItems[];
  tag: QuotationType;
}

export interface QuoteItems {
  quoteItemId: string;
  name: string;
  description: string;
  code: string;
  category: CategoryModel;
  subCategory: SubCategoryModel;
  quantity: number;
  unitPrice: number;
  percentageComplete: number;
  itemCost: number;
}

export enum QuotationType {
  Quotation,
  Estimate,
}

export interface CategoryModel {
  id: string;
  name: string;
  rank: number;
}

export interface SubCategoryModel {
  id: string;
  name: string;
  rank: number;
}
