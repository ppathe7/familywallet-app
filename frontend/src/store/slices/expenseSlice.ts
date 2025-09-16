import {createSlice, createAsyncThunk, PayloadAction} from '@reduxjs/toolkit';
import {expenseService} from '../services/expenseService';

interface Expense {
  id: string;
  amount: number;
  categoryId: string;
  description: string;
  storeName: string;
  receiptImageUrl?: string;
  locationData?: any;
  createdAt: string;
  updatedAt: string;
}

interface ExpenseState {
  expenses: Expense[];
  isLoading: boolean;
  error: string | null;
  monthlyBudget: number;
  categoryBudgets: {[key: string]: number};
}

const initialState: ExpenseState = {
  expenses: [],
  isLoading: false,
  error: null,
  monthlyBudget: 0,
  categoryBudgets: {},
};

export const fetchExpenses = createAsyncThunk(
  'expenses/fetchExpenses',
  async (filters?: {startDate?: string; endDate?: string; categoryId?: string}) => {
    const response = await expenseService.getExpenses(filters);
    return response;
  }
);

export const addExpense = createAsyncThunk(
  'expenses/addExpense',
  async (expenseData: Omit<Expense, 'id' | 'createdAt' | 'updatedAt'>) => {
    const response = await expenseService.createExpense(expenseData);
    return response;
  }
);

export const updateExpense = createAsyncThunk(
  'expenses/updateExpense',
  async ({id, ...expenseData}: Partial<Expense> & {id: string}) => {
    const response = await expenseService.updateExpense(id, expenseData);
    return response;
  }
);

export const deleteExpense = createAsyncThunk(
  'expenses/deleteExpense',
  async (id: string) => {
    await expenseService.deleteExpense(id);
    return id;
  }
);

const expenseSlice = createSlice({
  name: 'expenses',
  initialState,
  reducers: {
    clearError: state => {
      state.error = null;
    },
    setMonthlyBudget: (state, action: PayloadAction<number>) => {
      state.monthlyBudget = action.payload;
    },
    setCategoryBudget: (state, action: PayloadAction<{categoryId: string; amount: number}>) => {
      state.categoryBudgets[action.payload.categoryId] = action.payload.amount;
    },
  },
  extraReducers: builder => {
    builder
      .addCase(fetchExpenses.pending, state => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(fetchExpenses.fulfilled, (state, action) => {
        state.isLoading = false;
        state.expenses = action.payload;
      })
      .addCase(fetchExpenses.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.error.message || 'Failed to fetch expenses';
      })
      .addCase(addExpense.fulfilled, (state, action) => {
        state.expenses.unshift(action.payload);
      })
      .addCase(updateExpense.fulfilled, (state, action) => {
        const index = state.expenses.findIndex(expense => expense.id === action.payload.id);
        if (index !== -1) {
          state.expenses[index] = action.payload;
        }
      })
      .addCase(deleteExpense.fulfilled, (state, action) => {
        state.expenses = state.expenses.filter(expense => expense.id !== action.payload);
      });
  },
});

export const {clearError, setMonthlyBudget, setCategoryBudget} = expenseSlice.actions;
export default expenseSlice.reducer;
