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
    items: LineItemResponse[];
}

export interface CategoryModel {
    id: string;
    name: string;
    rank: number;
}

export interface LineItemResponse {
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