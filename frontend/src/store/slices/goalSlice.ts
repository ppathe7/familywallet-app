import {createSlice, createAsyncThunk, PayloadAction} from '@reduxjs/toolkit';
import {goalService} from '../services/goalService';

interface Goal {
  id: string;
  userId: string;
  familyId: string;
  goalName: string;
  targetAmount: number;
  currentAmount: number;
  deadline: string;
  monthlyContribution: number;
  createdAt: string;
  updatedAt: string;
}

interface GoalState {
  goals: Goal[];
  isLoading: boolean;
  error: string | null;
}

const initialState: GoalState = {
  goals: [],
  isLoading: false,
  error: null,
};

export const fetchGoals = createAsyncThunk(
  'goals/fetchGoals',
  async () => {
    const response = await goalService.getGoals();
    return response;
  }
);

export const addGoal = createAsyncThunk(
  'goals/addGoal',
  async (goalData: Omit<Goal, 'id' | 'createdAt' | 'updatedAt' | 'currentAmount'>) => {
    const response = await goalService.createGoal(goalData);
    return response;
  }
);

export const updateGoal = createAsyncThunk(
  'goals/updateGoal',
  async ({id, ...goalData}: Partial<Goal> & {id: string}) => {
    const response = await goalService.updateGoal(id, goalData);
    return response;
  }
);

export const deleteGoal = createAsyncThunk(
  'goals/deleteGoal',
  async (id: string) => {
    await goalService.deleteGoal(id);
    return id;
  }
);

export const addContribution = createAsyncThunk(
  'goals/addContribution',
  async ({goalId, amount}: {goalId: string; amount: number}) => {
    const response = await goalService.addContribution(goalId, amount);
    return response;
  }
);

const goalSlice = createSlice({
  name: 'goals',
  initialState,
  reducers: {
    clearError: state => {
      state.error = null;
    },
  },
  extraReducers: builder => {
    builder
      .addCase(fetchGoals.pending, state => {
        state.isLoading = true;
        state.error = null;
      })
      .addCase(fetchGoals.fulfilled, (state, action) => {
        state.isLoading = false;
        state.goals = action.payload;
      })
      .addCase(fetchGoals.rejected, (state, action) => {
        state.isLoading = false;
        state.error = action.error.message || 'Failed to fetch goals';
      })
      .addCase(addGoal.fulfilled, (state, action) => {
        state.goals.push(action.payload);
      })
      .addCase(updateGoal.fulfilled, (state, action) => {
        const index = state.goals.findIndex(goal => goal.id === action.payload.id);
        if (index !== -1) {
          state.goals[index] = action.payload;
        }
      })
      .addCase(deleteGoal.fulfilled, (state, action) => {
        state.goals = state.goals.filter(goal => goal.id !== action.payload);
      })
      .addCase(addContribution.fulfilled, (state, action) => {
        const index = state.goals.findIndex(goal => goal.id === action.payload.id);
        if (index !== -1) {
          state.goals[index] = action.payload;
        }
      });
  },
});

export const {clearError} = goalSlice.actions;
export default goalSlice.reducer;
