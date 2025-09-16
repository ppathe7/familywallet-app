import {createSlice, createAsyncThunk, PayloadAction} from '@reduxjs/toolkit';
import {portfolioService} from '../services/portfolioService';

interface PortfolioAsset {
  id: string;
  symbol: string;
  assetType: string;
  quantity: number;
  purchasePrice: number;
  purchaseDate: string;
  currentPrice: number;
  createdAt: string;
  updatedAt: string;
}

interface PortfolioState {
  assets: PortfolioAsset[];
  isLoading: boolean;
  error: string | null;
  totalValue: number;
  totalGainLoss: number;
  totalGainLossPercentage: number;
}

const initialState: PortfolioState = {
  assets: [],
  isLoading: false,
  error: null,
  totalValue: 0,
  totalGainLoss: 0,
  totalGainLossPercentage: 0,
};

export const fetchPortfolio = createAsyncThunk(
  'portfolio/fetchPortfolio',
  async () => {
    const response = await portfolioService.getPortfolio();
    return response;
  }
);

export const addAsset = createAsyncThunk(
  'portfolio/addAsset',
  async (assetData: Omit<PortfolioAsset, 'id' | 'createdAt' | 'updatedAt' | 'currentPrice'>) => {
    const response = await portfolioService.addAsset(assetData);
    return response;
  }
);

export const updateAsset = createAsyncThunk(
  'portfolio/updateAsset',
  async ({id, ...assetData}: Partial<PortfolioAsset> & {id: string}) => {
    const response = await portfolioService.updateAsset(id, assetData);
    return response;
  }
);

export const deleteAsset = createAsyncThunk(
  'portfolio/deleteAsset',
  async (id: string) => {
    await portfolioService.deleteAsset(id);
    return id;
  }
);

export const updatePrices = createAsyncThunk(
  'portfolio/updatePrices',
  async () => {
    const response = await portfolioService.updatePrices();
    return response;
  }
);

const portfolioSlice = createSlice({
  name: 'portfolio',
  initialState,
  reducers: {
    clearError: state => {
      state.error = null;
    },
    calculateTotals: state => {
      state.totalValue = state.assets.reduce((sum, asset) => sum + (asset.quantity * asset.currentPrice), 0);
      const totalCost = state.assets.reduce((sum, asset) => sum + (asset.quantity * asset.purchasePrice), 0);
      state.totalGainLoss = state.totalValue - totalCost;
      state.totalGainLossPercentage = totalCost > 0 ? (state.totalGainLoss / totalCost) * 100 : 0;
    },
  },
  extraReducers: builder => {
    builder
      .addCase(fetchPortfolio.pending, state => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(fetchPortfolio.fulfilled, (state, action) => {
        state.isLoading = false;
        state.assets = action.payload;
      })
      .addCase(fetchPortfolio.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.error.message || 'Failed to fetch portfolio';
      })
      .addCase(addAsset.fulfilled, (state, action) => {
        state.assets.push(action.payload);
      })
      .addCase(updateAsset.fulfilled, (state, action) => {
        const index = state.assets.findIndex(asset => asset.id === action.payload.id);
        if (index !== -1) {
          state.assets[index] = action.payload;
        }
      })
      .addCase(deleteAsset.fulfilled, (state, action) => {
        state.assets = state.assets.filter(asset => asset.id !== action.payload);
      })
      .addCase(updatePrices.fulfilled, (state, action) => {
        state.assets = action.payload;
      });
  },
});

export const {clearError, calculateTotals} = portfolioSlice.actions;
export default portfolioSlice.reducer;
