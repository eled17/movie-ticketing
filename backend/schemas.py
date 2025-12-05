from pydantic import BaseModel

class MovieBase(BaseModel):
    title: str
    description: str


class MovieCreate(MovieBase):
    pass


class Movie(MovieBase):
    id: int

    class Config:
        orm_mode = True


class ShowtimeBase(BaseModel):
    movie_id: int
    time: str


class ShowtimeCreate(ShowtimeBase):
    pass


class Showtime(ShowtimeBase):
    id: int

    class Config:
        orm_mode = True


class TicketBase(BaseModel):
    showtime_id: int
    seat_number: str
    user_id: int


class TicketCreate(TicketBase):
    pass


class Ticket(TicketBase):
    id: int

    class Config:
        orm_mode = True


class UserBase(BaseModel):
    email: str
    password: str  # stored plain text as you requested

class UserCreate(UserBase):
    pass

class User(UserBase):
    id: int

    class Config:
        orm_mode = True
