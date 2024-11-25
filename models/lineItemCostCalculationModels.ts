import {type CategoryModel} from "./categoryModels";

export interface LineItemCostCalculationCreateRequest {
    name: string;
    description: string;
    code: string;
    category: CategoryModel;
    markupPercentage: number;
    subTotal: number;
    total: number;
    markupCost: number;
    items: LineItem[];
}

export interface LineItemCostCalculationResponse {
    id: string;
    name: string;
    description: string;
    code: string;
    category: CategoryModel;
    markupPercentage: number;
    subTotal: number;
    total: number;
    markupCost: number;
    items: LineItem[];
}

export interface LineItem{
    id: string;
    name: string;
    itemDescription: string;
    code: string;
    unitOfMeasure: string;
    listDiscountPercentage: number;
    quantityPerItem: number;
    listPrice: number;
    quantityRequired: number;
    discountPrice: number;
    wasteAllowedPrice: number;
    wasteAllowedPercentage: number;
    listQuantity: number;
    totalCost: number;
    tag: Tag;
}

export enum Tag {
    Material,
    Labour,
    Misc
}
